#!/usr/bin/env coffee

args = require("minimist")(process.argv.slice(2))
chalk = require "chalk"
{exec, spawn} = require "child_process"
request = require "request"
stdout = require 'stdout-stream'

DMAN_SERVER_DETAILS = "server-nas:7000"
REQ_TOKEN="UApgN9pEpZ5cj4NnOSChJqGp"

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

  when args._.indexOf('rebuild') isnt -1
    if args.slug
      request(
        url: "http://#{DMAN_SERVER_DETAILS}/rebuild?slug=/tmp/repos/#{args.slug}.git&token=#{REQ_TOKEN}"
        # url: "http://google.com"
        method: "get"
      ).on 'error', (e) ->
        if e.code is 'ECONNREFUSED'
          console.log chalk.red "If doesn't seem like your deployman server is up right now."
        else
          console.log chalk.red "Ummmm.... Well.... Something just happened....\n#{e}"
      .pipe stdout
    else
      console.log chalk.red "You didn't format it right!"


  when args._.indexOf('ports') isnt -1
    if args.slug
      request
        url: "http://#{DMAN_SERVER_DETAILS}/ports?slug=/tmp/repos/#{args.slug}.git&token=#{REQ_TOKEN}"
        # url: "http://google.com"
        method: "get"
      , (err, resp, body) ->
        if err and err.code is 'ECONNREFUSED'
          console.log chalk.red "If doesn't seem like your deployman server is up right now."
        else if err
          console.log chalk.red "Ummmm.... Well.... Something just happened....\n#{e}"
        else
          console.log "Ports for #{args.slug}:"
          for dest, source of JSON.parse(body).ports
            console.log "#{chalk.green source} -> #{chalk.cyan dest}"
    else
      console.log chalk.red "You didn't format it right!"



  when args.help or args._.length is 0
    console.log """
    Usage: dman [action] --argument value

    Arguments to specify:
    * #{chalk.cyan "--slug slugname"} specify a slug to a command

    * #{chalk.cyan "addremote"} use the specified slug name to add a remote
    to the current git repo. Like #{chalk.green "dman addremote --slug my-app --user my-username --pass my-password"}

    * #{chalk.cyan "rebuild"} rebuild the specified slug. Like #{chalk.green "dman rebuild --slug my-app"}

    * #{chalk.cyan "ports"} get the bound ports for a slug. Like #{chalk.green "dman ports --slug my-app"}
    """


  else
    console.log "No such action. Take a look at #{chalk.green "dman --help"} for help."
