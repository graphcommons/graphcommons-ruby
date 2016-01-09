#! /bin/ruby

require 'rest-client'
require 'json'
require 'pp'

module GraphCommons

  class APIError < RuntimeError
  end

  class API

    @@apiurl = "https://graphcommons.com/api/v1"
    @@apikey ||= ENV["GRAPHCOMMONS_API_KEY"]
    @@verbose = false

    def self.get endpoint, options = {}
      uri = self._gd(endpoint, options)
      puts "GET #{uri}" if @@verbose
      RestClient.get(uri,:authentication=>@@apikey,:content_type=>"application/json") {|data| self._respond data, uri, options}
    end

    def self.delete endpoint, options = {}
      uri = self._gd(endpoint, options)
      puts "DELETE #{uri}" if @@verbose
      RestClient.delete(uri,:authentication=>@@apikey,:content_type=>"application/json") {|data| self._respond data, uri, options}
    end

    def self.post endpoint, options = {}
      uri, query = self._pp endpoint, options
      puts "POST #{uri} #{query}" if @@verbose
      RestClient.post(uri,query.to_json,:authentication=>@@apikey,:content_type=>"application/json") {|data| self._respond data, uri, query}
    end

    def self.put endpoint, options = {}
      uri, query = self._pp endpoint, options
      puts "PUT #{uri} #{query}" if @@verbose
      RestClient.put(uri,query.to_json,:authentication=>@@apikey,:content_type=>"application/json") {|data| self._respond data, uri, query}
    end

    def self.set_key key
      if @@apikey == key
        return false
      else
        @@apikey = key
        true
      end
    end

    def self.check_key
      raise GraphCommons::APIError.new("API key not set\nHint: use GraphCommons::API.set_key method or GRAPHCOMMONS_API_KEY environment variable.") unless @@apikey and @@apikey.length > 3
    end

    def self.verbose
      @@verbose
    end

    def self.verbose!
      @@verbose = true
    end

    def self.quiet!
      @@verbose = false
      true
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
          raise GraphCommons::APIError.new(error)
        else
          return data
        end
      end
    end

    def self._gd endpoint, options
      self.check_key
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
      self.check_key
      ep = endpoint.to_s.gsub /(^\/|\/$)/, ""
      id = options.delete :id if options.has_key? :id
      id = options.delete "id" if options.has_key? "id"
      uri = "#{@@apiurl}/#{ep.split(/\//)[0]}/#{id}"
      uri += "/#{ep.split(/\//)[1..-1].join("/")}" if ep.match /\//
      uri = uri.gsub(/\/\//,"/").sub(/\//,"//")
      return uri, options
    end
  end

  class Search < API
    def self.graphs query={}
      self.get "graphs/search", query
    end
    def self.nodes query={}
      self.get "nodes/search", query
    end
    def self.search query={}
      self.get "search", query
    end
  end

  class Endpoint < API

    def self.status
      self.get :status
    end

    #Graph operations
    def self.new_graph options
      self.post :graphs, options
    end

    def self.get_graph id
      self.get :graphs, :id => id
    end

    def self.get_graph_types id
      self.get "graphs/types", :id => id
    end

    def self.get_graph_edges id, options
      options[:id] = id
      self.get "graphs/edges", options
    end

    def self.get_graph_paths id, options
      options[:id] = id
      self.get "graphs/paths", options
    end

    def self.update_graph id, options
      self.put :graphs, :id => id, :graph=> options
    end

    def self.delete_graph id
      self.delete :graphs, :id => id
    end

    #Node operations
    def self.get_node id
      self.get :nodes, :id => id
    end

    #Hub operations
    def self.get_hub id
      self.get :hubs, :id => id
    end

    def self.get_hub_types id
      self.get "hubs/types", :id => id
    end

    def self.get_hub_paths id, options
      options[:id] = id
      self.get "hubs/paths", options
    end

    def self.get_hub_graphs id, options
      options[:id] = id
      self.get "graphs/search", options
    end

    def self.get_hub_nodes id, options
      options[:id] = id
      self.get "nodes/search", options
    end

  end

  class Signal < API

    def self.node_create id, options
      options[:action] = :node_create
      self._signal id, options
    end

    def self.edge_create id, options
      options[:action] = :edge_create
      self._signal id, options
    end

    def self.node_update id, options
      options[:action] = :node_update
      self._signal id, options
    end

    def self.edge_update id, options
      options[:action] = :edge_update
      self._signal id, options
    end

    def self.node_delete id, options
      options[:action] = :node_delete
      self._signal id, options
    end

    def self.edge_delete id, options
      options[:action] = :edge_delete
      self._signal id, options
    end

    def self.nodetype_update id, options
      options[:action] = :nodetype_update
      self._signal id, options
    end

    def self.edgetype_update id, options
      options[:action] = :edgetype_update
      self._signal id, options
    end

    def self.nodetype_delete id, options
      options[:action] = :nodetype_delete
      self._signal id, options
    end

    def self.edgetype_delete id, options
      options[:action] = :edgetype_delete
      self._signal id, options
    end

    private
    def self._signal id, options
      self.put "graphs/add", :id => id, :signals => [options]
    end

  end

end

