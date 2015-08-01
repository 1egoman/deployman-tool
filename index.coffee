#!/usr/bin/env coffee

args = require("minimist")(process.argv.slice(2))
chalk = require "chalk"
{exec, spawn} = require "child_process"
DMAN_SERVER_DETAILS = "192.168.1.9:7000"

switch

  when args._.indexOf('addremote') isnt -1
    if args.user and args.pass and args.slug
      [username, password, slug] = [args.user, args.pass, args.slug]
      remote = "http://#{username}:#{password}@#{DMAN_SERVER_DETAILS}/#{slug}.git"
      console.log "remote = #{chalk.green remote}"
      
      # lets for real create this remote
      exec "git remote add #{"prod" or args.name} #{remote}", (e, out, err) ->
        if e
          console.log chalk.red e
        else
          console.log chalk.green "Looks good - try pushing to your new remote #{chalk.cyan "prod" or args.name}!!"
    else
      console.log chalk.red "You didn't format it right!"



  when args.help or args._.length is 0
    console.log """
    Usage: dman [action] --argument value

    Arguments to specify:
    * #{chalk.cyan "--slug slugname"} specify a slug to a command

    * #{chalk.cyan "addremote"} use the specified slug name to add a remote
    to the current git repo. Like #{chalk.green "dman addremote --slug my-app --user my-username --pass my-password"}
    """


  else
    console.log "No such action. Take a look at #{chalk.green "dman --help"} for help."
