# hubot-gh-issues

Hubot interface for GitHub issues

See [`src/gh-issues.coffee`](src/gh-issues.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-gh-issues --save`

Then add **hubot-gh-issues** to your `external-scripts.json`:

```json
["hubot-gh-issues"]
```

## Dependencies

  * `hubot-gh-token`

## Configuration

  * `HUBOT_GH_ISSUES_DEFAULT_OWNER`
  * `HUBOT_GH_ISSUES_DEFAULT_REPO`

## Sample Interaction

```
user1>> hubot github open issue "everything is broken!" about "all of the things are broken, help!" in "somecompany/somerepo" with labels "things"
hubot>> Created issue #4 in somecompany/somerepo - https://github.com/somecompany/somerepo/issues/4
```
