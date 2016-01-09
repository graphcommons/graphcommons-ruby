# graphcommons
Ruby wrapper for Graphcommons API. 

More info at: [http://graphcommons.github.io/api-v1/](http://graphcommons.github.io/api-v1/ "API reference")

## installation
```
$ gem install graphcommons
```

## usage
First, add your key as an environment variable:
```
export GRAPHCOMMONS_API_KEY="XX_XXXXXXXXXXXXXXXXXXXXXX"
```
Then require the gem and you're good to go.
```
#irb

:001 > require 'graphcommons'
=> true 

:002 > GraphCommons::Endpoint.status
=> {"msg"=>"Working"} 
```
Alternatively, you can use the `GraphCommons::API.set_key` method.
