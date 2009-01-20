# Knapsack: pack pages into data URIs.

Initial development: Joseph Pearson (Inventive Labs)
Home: http://github.com/inventive/knapsack/tree/master


## What is Knapsack?

Knapsack is a simple web service that takes a URL, pulls down the resource and
all the resources it references, and 'compiles' them into a data URI. What's
interesting about a data URI is that you can bookmark it and access it offline.
This can be really useful if you have a device that has an intermittent net
connection (an iPod Touch, for instance).

It works a lot like Hixie's [Data URI 
Kitchen](http://software.hixie.ch/utilities/cgi/data/data), but it preserves
images, stylesheets and external javascript libraries.

You can install it on any web server that supports Rack.


## License

Copyright (C) 2009 Inventive Labs.

Released under the WTFPL: http://sam.zoy.org/wtfpl.
