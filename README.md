
# graphcommons-ruby
[![version: 0.0.5](https://img.shields.io/badge/version-0.0.5-lightgrey.svg?style=flat-square)](https://rubygems.org/gems/graphcommons)
[![docs: rubydoc.info](https://img.shields.io/badge/docs-rubydoc.info-red.svg?style=flat-square)](http://www.rubydoc.info/gems/graphcommons)
[![example: metagraph](https://img.shields.io/badge/example-metagraph-blue.svg?style=flat-square)](https://github.com/graphcommons/metagraph)
[![license: GPLv3](https://img.shields.io/badge/license-GPLv3-brightgreen.svg?style=flat-square)](https://www.gnu.org/licenses/gpl.txt)

Ruby wrapper for [Graphcommons API](http://graphcommons.github.io/api-v1/ "API reference"):

> Graph Commons provides a simple REST API to programmatically make network maps (graphs) and integrate graphs into your applications. You can use our API to access Graph Commons API endpoints, which can get information on various graphs, nodes, and edges on the platform.
> 
> To get started, sign up to Graph Commons and get your developer key, which will be used for authentication in your API calls.

## Installation
```
$ gem install graphcommons
```

## Usage
First, add your key as an environment variable:

```
export GRAPHCOMMONS_API_KEY="XX_XXXXXXXXXXXXXXXXXXXXXX"
```

Then require the gem and you're good to go.

```
#irb

:001 > require 'graphcommons'
=> true 

:002 > Graphcommons::Endpoint.status
=> {"msg"=>"Working"} 
```

Alternatively, you can use the `Graphcommons::API.set_key` method. Please refer to the [docs](http://www.rubydoc.info/gems/graphcommons "rubydoc.info") for more information.

