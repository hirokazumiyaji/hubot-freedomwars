# Description:
#   Freedomwars
#
# Commands:
#   hubot freedomwars hevenjudgement
#
# Author:
#  HirokazuMiayji

Select     = require("soupselect").select
HtmlParser = require "htmlparser"

module.exports = (robot) ->
  robot.respond /freedomwars hevenjudgment/i, (msg) ->
    url_prefix = 'http://www.jp.playstation.com/scej/title/freedomwars/stat'
    msg.http("#{url_prefix}/index.html").get() (err, res, body) ->
      if res.statusCode isnt 200
        msg.send "Error #{res.statusCode}"
        return

      if res.headers['content-type'].indexOf('text/html') != 0
        msg.send "Validate Error"
        return

      handler = new HtmlParser.DefaultHandler()
      parser  = new HtmlParser.Parser handler
      parser.parseComplete body

      try
        results = (Select handler.dom, "div#forecastBlock dl dd")
      catch RangeError
        msg.send "Parse Error"

      # img tag string parse. url of src
      img_tag = results[0].children[0].raw
      img_tag = img_tag.replace /.*src=\"/g, ""
      img_src = img_tag.replace /\".*$/g, ""
      msg.send "#{url_prefix}/#{img_src}"
