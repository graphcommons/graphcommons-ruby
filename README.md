
# graphcommons-ruby
[![version: 0.0.5](https://img.shields.io/badge/version-0.0.5-lightgrey.svg?style=flat-square)](https://rubygems.org/gems/graphcommons)
[![license: GPLv3](https://img.shields.io/badge/license-GPLv3-brightgreen.svg?style=flat-square)](https://www.gnu.org/licenses/gpl.txt)
[![example: metagraph](https://img.shields.io/badge/example-metagraph-blue.svg?style=flat-square)](https://github.com/graphcommons/metagraph)
[![docs: rubydoc.info](https://img.shields.io/badge/docs-rubydoc.info-red.svg?style=flat-square)](http://www.rubydoc.info/gems/graphcommons)

Ruby wrapper for [Graphcommons API](http://graphcommons.github.io/api-v1/ "API reference")

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

Alternatively, you can use the `Graphcommons::API.set_key` method.

