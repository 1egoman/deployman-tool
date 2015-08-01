#!/usr/bin/env coffee

args = require("minimist")(process.argv.slice(2))
chalk = require "chalk"
DMAN_SERVER_DETAILS = ""

switch

  when args._.indexOf('addremote') isnt -1
    console.log 1
    remote = "http://"



  when args.help or args._.length is 0
    console.log """
    Usage: dman [action] --argument value

    Arguments to specify:
    * #{chalk.cyan "--slug slugname"} specify a slug to a command

    * #{chalk.cyan "addremote"} use the specified slug name to add a remote
    to the current git repo. Like #{chalk.green "dman addremote --slug my-app"}
    """


  else
    console.log "No such action. Take a look at #{chalk.green "dman --help"} for help."
