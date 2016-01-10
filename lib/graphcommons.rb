#! /bin/ruby

require 'rest-client'
require 'json'
require 'pp'

# Ruby wrapper for Graphcommons REST API that is used
# to programmatically make network maps (graphs) and integrate graphs into your
# applications. 
#
# To get started, sign up to Graph Commons and get your developer key, which
# will be used for authentication in your API calls.
#
# More info at: http://graphcommons.github.io/api-v1/

module Graphcommons

  @@verbose = false
  # Check verbose output. Default is +false+.
  def self.verbose
    @@verbose
  end

  # Switch on verbose output.
  def self.verbose!
    @@verbose = true
  end

  # Switch off verbose output.
  def self.quiet!
    @@verbose = false
    true
  end

  # Custom error class for Graphcommons API.
  #
  # Set +Graphcommons.verbose+ to +true+ in order to get stack trace.
  class APIError < RuntimeError
    # :nodoc:
    def backtrace
      if Graphcommons.verbose
        caller
      else
        []
      end
    end
  end

  # Low-level wrapper for API calls.
  class API

    @@apiurl = "https://graphcommons.com/api/v1"
    @@apikey ||= ENV["GRAPHCOMMONS_API_KEY"]

    # Handles *GET* requests, returns API response as ruby hash.
    def self.get endpoint, options = {}
      uri = self._gd(endpoint, options)
      puts "GET #{uri}" if Graphcommons.verbose
      RestClient.get(uri,:authentication=>@@apikey,:content_type=>"application/json") {|data| self._respond data, uri, options}
    end

    # Handles *DELETE* requests, returns API response as ruby hash.
    def self.delete endpoint, options = {}
      uri = self._gd(endpoint, options)
      puts "DELETE #{uri}" if Graphcommons.verbose
      RestClient.delete(uri,:authentication=>@@apikey,:content_type=>"application/json") {|data| self._respond data, uri, options}
    end

    # Handles *POST* requests, returns API response as ruby hash.
    def self.post endpoint, options = {}
      uri, query = self._pp endpoint, options
      puts "POST #{uri} #{query}" if Graphcommons.verbose
      RestClient.post(uri,query.to_json,:authentication=>@@apikey,:content_type=>"application/json") {|data| self._respond data, uri, query}
    end

    # Handles *PUT* requests, returns API response as ruby hash.
    def self.put endpoint, options = {}
      uri, query = self._pp endpoint, options
      puts "PUT #{uri} #{query}" if Graphcommons.verbose
      RestClient.put(uri,query.to_json,:authentication=>@@apikey,:content_type=>"application/json") {|data| self._respond data, uri, query}
    end

    # Sets API key. 
    #
    # Returns +true+ if key is changed, +false+ if not changed, raises APIError
    # if key argument fails /^sk_.\{22\}$/ test.
    #
    # To get the key, please visit https://graphcommons.com/me/edit
    def self.set_key key
      raise Graphcommons::APIError.new("Invalid API key\nKey should be in following format: sk_XXXXXXXXXXXXXXXXXXXXXX") unless key.match(/^sk_.{22}$/)
      if @@apikey == key
        return false
      else
        @@apikey = key
        true
      end
    end

    # Checks API key to /^sk_.\{22\}$/ test.
    # 
    # Returns +true+ or +false+.
    def self.check_key
      @@apikey and @@apikey.length > 3
    end

    private
    def self._respond data, uri, query={}
      begin
        return JSON.parse(data)
      rescue
        if match = data.match(/status[^\w]+\d\d\d[^\w]+status/)
          code = match.to_s.gsub(/\D/,"")
          error = ["Not found","Server error"][code[0].to_i-4]+" (#{code})\nURI: #{uri}"
          error += "\nQUERY: #{query.to_json}" if query.any?
          raise Graphcommons::APIError.new(error)
        else
          return data
        end
      end
    end

    def self._gd endpoint, options
      raise Graphcommons::APIError.new("API key not set\nHint: use Graphcommons::API.set_key method or GRAPHCOMMONS_API_KEY environment variable.") unless self.check_key
      ep = endpoint.to_s.gsub /(^\/|\/$)/, ""
      options[:query] = "*" if (!options.has_key?(:query) or !options.has_key?("query")) and ep.match(/search/)
      id = options.delete :id if options.has_key? :id
      id = options.delete "id" if options.has_key? "id"
      uri = "#{@@apiurl}/#{ep.split(/\//)[0]}/#{id}"
      uri += "/#{ep.split(/\//)[1..-1].join("/")}" if ep.match /\//
      uri += "?#{options.map{|k,v| "#{k}=#{v}"}.join("&")}" if options.any?
      uri = uri.gsub(/\/\//,"/").sub(/\//,"//")
    end

    def self._pp endpoint, options
      raise Graphcommons::APIError.new("API key not set\nHint: use Graphcommons::API.set_key method or GRAPHCOMMONS_API_KEY environment variable.") unless self.check_key
      ep = endpoint.to_s.gsub /(^\/|\/$)/, ""
      id = options.delete :id if options.has_key? :id
      id = options.delete "id" if options.has_key? "id"
      uri = "#{@@apiurl}/#{ep.split(/\//)[0]}/#{id}"
      uri += "/#{ep.split(/\//)[1..-1].join("/")}" if ep.match /\//
      uri = uri.gsub(/\/\//,"/").sub(/\//,"//")
      return uri, options
    end
  end

  # Wrapper for *search* endpoints in the API.
  class Search < API
    # Search for *graphs*.
    def self.graphs query={}
      self.get "graphs/search", query
    end
    # Search for *nodes*.
    def self.nodes query={}
      self.get "nodes/search", query
    end
    # Search through *users*, *graphs* and *nodes*.
    def self.search query={}
      self.get "search", query
    end
  end

  # Wrapper for general methods in the API.
  class Endpoint < API

    # Get API status.
    # http://graphcommons.github.io/api-v1/#get-status
    def self.status
      self.get :status
    end

    # Create new graph.
    # Required options: +:name+
    #
    # http://graphcommons.github.io/api-v1/#post-graphs
    def self.new_graph options
      self.post :graphs, options
    end

    # Get graph by *:id*.
    #
    # http://graphcommons.github.io/api-v1/#get-graphs-id
    def self.get_graph id
      self.get :graphs, :id => id
    end

    # Get node and edge types inside graph with *:id*.
    #
    # http://graphcommons.github.io/api-v1/#get-graphs-id-types
    def self.get_graph_types id
      self.get "graphs/types", :id => id
    end

    # Get edges inside graph with *:id*.
    #
    # http://graphcommons.github.io/api-v1/#get-graphs-id-edges
    def self.get_graph_edges id, options
      options[:id] = id
      self.get "graphs/edges", options
    end

    # Query for paths inside graph with *:id*.
    #
    # http://graphcommons.github.io/api-v1/#get-graphs-id-paths
    # http://graphcommons.github.io/api-v1/#paths-endpoint-details
    def self.get_graph_paths id, options
      options[:id] = id
      self.get "graphs/paths", options
    end

    # Modify attributes of graph with *:id*.
    #
    # http://graphcommons.github.io/api-v1/#put-graphs-id
    def self.update_graph id, options
      self.put :graphs, :id => id, :graph=> options
    end

    # Delete graph with *:id*.
    #
    # http://graphcommons.github.io/api-v1/#delete-graphs-id
    def self.delete_graph id
      self.delete :graphs, :id => id
    end

    # Get node by *:id*.
    #
    # http://graphcommons.github.io/api-v1/#get-nodes-id
    def self.get_node id
      self.get :nodes, :id => id
    end

    # Get hub by *:id*.
    #
    # http://graphcommons.github.io/api-v1/#get-hubs-id
    def self.get_hub id
      self.get :hubs, :id => id
    end

    # Get node and edge types in hub with *:id*.
    #
    # http://graphcommons.github.io/api-v1/#get-hubs-id-types
    def self.get_hub_types id
      self.get "hubs/types", :id => id
    end

    # Query for paths inside hub with *:id*.
    #
    # http://graphcommons.github.io/api-v1/#get-hubs-id-paths
    # http://graphcommons.github.io/api-v1/#paths-endpoint-details
    def self.get_hub_paths id, options
      options[:id] = id
      self.get "hubs/paths", options
    end

    # Search for graphs inside hub with *:id*.
    #
    # http://graphcommons.github.io/api-v1/#get-hubs-id-graphs
    def self.get_hub_graphs id, options
      options[:id] = id
      self.get "graphs/search", options
    end

    # Search for nodes inside  hub with *:id*.
    #
    # http://graphcommons.github.io/api-v1/#get-hubs-id-nodes
    def self.get_hub_nodes id, options
      options[:id] = id
      self.get "nodes/search", options
    end

  end

  # Changes to the nodes and edges of a graph are carried out by a series of
  # commands called signals in the request body. With these signals you can
  # add, update or delete nodes, edges, node types and edge types.
  #
  # Mind that +:id+ parameter is required in all calls.
  class Signal < API

    # This signal type is used for creating nodes. All signals of this type
    # must define a type and name key. type - name pairs must be unique.
    #
    # Upon saving this signal, a new node id is created. The type of the node
    # is matched with a predefined node type from the hub/graph. If the node
    # type does not already exist, a node type is created.
    #
    # Required options: +:name+, +:type+
    #
    # http://graphcommons.github.io/api-v1/#node_create
    def self.node_create id, options
      options[:action] = :node_create
      self._signal id, options
    end

    # This signal type is used for creating edges. Source and target nodes for
    # the edge will be created if they don’t already exist. Only one instance
    # of edgetype is allowed between the same nodes. However, there could be
    # multiple edges between the same node pair, as long as the their edge
    # types are different.
    #
    # Upon saving this signal a new edge id is created. The type of the edge is
    # matched with a predefined edge type from the hub/graph. If the edge type
    # does not already exist, a new edge type is created.
    #
    # Required options: +:from_type+, +:from_name+, +:to_type+, +:to_name+, +:name+
    #
    # http://graphcommons.github.io/api-v1/#edge_create
    def self.edge_create id, options
      options[:action] = :edge_create
      self._signal id, options
    end

    # This signal type is used for updating a node. All fields except for id
    # will be updated in the node.
    #
    # http://graphcommons.github.io/api-v1/#node_update
    def self.node_update id, options
      options[:action] = :node_update
      self._signal id, options
    end

    # This signal type is used for updating an edge. All fields except for id
    # will be updated in the node.
    # 
    # Required options: +:from+, +:to+
    #
    # http://graphcommons.github.io/api-v1/#edge_update
    def self.edge_update id, options
      options[:action] = :edge_update
      self._signal id, options
    end

    # This signal type is used for deleting nodes.
    #
    # http://graphcommons.github.io/api-v1/#node_delete
    def self.node_delete id, options
      options[:action] = :node_delete
      self._signal id, options
    end

    # This signal type is used for deleting edges.
    #
    # http://graphcommons.github.io/api-v1/#edge_delete
    def self.edge_delete id, options
      options[:action] = :edge_delete
      self._signal id, options
    end

    # http://graphcommons.github.io/api-v1/#nodetype_update
    def self.nodetype_update id, options
      options[:action] = :nodetype_update
      self._signal id, options
    end

    # http://graphcommons.github.io/api-v1/#edgetype_update
    def self.edgetype_update id, options
      options[:action] = :edgetype_update
      self._signal id, options
    end

    # http://graphcommons.github.io/api-v1/#nodetype_delete
    def self.nodetype_delete id, options
      options[:action] = :nodetype_delete
      self._signal id, options
    end

    # http://graphcommons.github.io/api-v1/#edgetype_delete
    def self.edgetype_delete id, options
      options[:action] = :edgetype_delete
      self._signal id, options
    end

    private
    def self._signal id, options
      options = [options] unless options.is_a? Array
      self.put "graphs/add", :id => id, :signals => options
    end

  end

end

