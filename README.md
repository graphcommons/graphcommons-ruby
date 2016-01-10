# Graphcommons
Ruby wrapper for [Graphcommons API](http://graphcommons.github.io/api-v1/ "API reference")

**Example**: [metagraph](https://github.com/graphcommons/metagraph "Source code")

**Docs**: [rubydoc.info](http://www.rubydoc.info/gems/graphcommons "Documentation")

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

