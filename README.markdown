#Keigan

Keigan is web interface for viewing a risu database

The name comes from the Japanese word for 'keen insight'.

# Requirements

##Ruby
Keigan has been tested with ruby-1.9.2-p320, ruby-1.9.3-p125. Please try to use one of these versions if possible. I recommend using RVM to setup your ruby environment you can get it [here](https://rvm.beginrescueend.com/).

### RubyGems
Keigan relies heavily on [RubyGems](http://rubygems.org/) to install other dependencies I highly recommend using it. RubyGems is included by default in the 1.9.x versions of [Ruby](http://ruby-lang.org/).

- rails
- yaml
- logger
- risu
- sinatra
- haml

# Installation
Installation is really easy just gem install!

	% gem install keigan

# Usage
It is assumed that you already have a working [risu](http://www.arxopia.com/projects/risu) installation, a configuration file and a parsed database.

## Step 1: Starting the service
Simply type in a console; by default Keigan will read a configuration file for database settings from the current directory. This means you should run it from the same directory as your risu database(sqlite) and configuration file.

	% keigan

Once the service boots up open a web browser and navigate to http://localhost:8869. Alternatively if you want the service to run in the background you can do the following.

	% keigan &

## Step 2: Navigating the website
Keigan displays everything in the database in a easy view manner.

### Pages
- dashboard
- scans
- hosts
- items
- plugins

# Contributing
If you would like to contribute to Keigan. The easiest way is to fork the project on [github](http://github.com/arxopia/keigan) and make the changes in your fork and the submit a pull request to the project.

# Issues
If you have any problems, bugs or feature requests please use the [github issue tracker](http://github.com/arxopia/keigan/issues).

# Copyrights
- keigan - (BSD) Copyright (C) 2012 Arxopia LLC.
- risu   - (BSD) Copyright (C) 2010-2012 Arxopia LLC.
- Bluff  - (MIT) Copyright (C) 2008-2010 James Coglan

# Contact
You can reach me at keigan[at]arxopia[dot]com.

You can also contact me on IRC as hammackj on irc.freenode.net, #risu
