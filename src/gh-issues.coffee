# Description
#   Hubot interface for GitHub issues
#
# Configuration:
#   HUBOT_GH_ISSUES_DEFAULT_OWNER
#   HUBOT_GH_ISSUES_DEFAULT_REPO
#
# Dependencies:
#   hubot-gh-token
#   octonode
#
# Commands:
#   hubot github open issue "<title>" (about "<body>") (in "(<owner>/)<repo>") (with labels "<label1>,<label2>,..") - Opens a new issue
#
# Author:
#   @benwtr

DEFAULT_OWNER = process.env.HUBOT_GH_ISSUES_DEFAULT_OWNER
DEFAULT_REPO = process.env.HUBOT_GH_ISSUES_DEFAULT_REPO

github = require 'octonode'

module.exports = (robot) ->

  githubTokenForUser = (msg) ->
    user = robot.brain.userForId msg.envelope.user.id
    token = robot.vault.forUser(user).get(robot.vault.key)
    return token if token?
    msg.reply "I don't know your GitHub token. \nPlease generate one with the \"repo\" scope on https://github.com/settings/tokens and set it in a private message to me with the command: \"github token set <github_personal_access_token>\""

  openIssue = (msg, title, body, repo, labels) ->
    token = githubTokenForUser msg
    if token?
      client = github.client token
      ghrepo = client.repo repo
      ghrepo.issue { "title": title, "body": body, "labels": labels }
      , (err, data, headers) ->
        unless err?
          msg.reply "Created issue ##{data.number} in #{repo} - #{data.html_url}"
        else
          msg.reply "Error from GitHub API: #{err.body.message}"

  robot.respond /(?:github|gh) (?:open|create|new) issue "([^"]+)"(?: (?:about|regarding|re|body|description) "([^"]+)")?(?: in "([\w\d-_]+)(?:\/([\w\d-_]+))?")?(?: (?:with )?(?:tags|tag|labels|label|tagged) "([\w\d,-_]+)")?$/i, id: 'gh-issues.open', (msg) ->
    title = msg.match[1]
    body = msg.match[2] || ''
    repo = if msg.match[3]? and msg.match[4]?
      "#{msg.match[3]}/#{msg.match[4]}"
    else if msg.match[3]?
      "#{DEFAULT_OWNER}/#{msg.match[3]}"
    else
      "#{DEFAULT_OWNER}/#{DEFAULT_REPO}"
    labels = if msg.match[5]? then msg.match[5].split(',') else []

    openIssue msg, title, body, repo, labels
