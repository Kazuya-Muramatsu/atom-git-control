fs = require 'fs'

Dialog = require './dialog'
git = require '../git'

module.exports =
class CommitDialog extends Dialog
  @content: ->
    @div class: 'dialog', =>
      @div class: 'heading', =>
        @i class: 'icon x clickable', click: 'cancel'
        @strong 'Commit'
      @div class: 'body', =>
        @label 'Commit Message'
        @textarea class: 'native-key-bindings', outlet: 'msg', keyUp: 'colorLength'
        @input type: 'checkbox', outlet: 'isAndPush', id: 'isAndPush'
        @label "Commit and Push", for: 'isAndPush', outlet: 'commitAndPushLabel'
      @div class: 'buttons', =>
        @button class: 'active', click: 'commit', =>
          @i class: 'icon commit'
          @span 'Commit'
        @button click: 'cancel', =>
          @i class: 'icon x'
          @span 'Cancel'

  activate: ->
    super()
    @msg.val('')
    @msg.focus()
    git.getConfigKey('commit.template').then (path) =>
      fs.readFile path, (err, data) =>
        if (err)
          @msg.val('')
        else
          @msg.val(data)
    @commitAndPushLabel.text("Commit and Push origin/#{git.getLocalBranch()}")
    return

  colorLength: ->
    too_long = false
    for line, i in @msg.val().split("\n")
      if (i == 0 && line.length > 50) || (i > 0 && line.length > 80)
        too_long = true
        break

    if too_long
      @msg.addClass('over-fifty')
    else
      @msg.removeClass('over-fifty')
    return

  commit: ->
    @deactivate()
    @parentView.commit()
    return

  getMessage: ->
    return "#{@msg.val()} "

  getIsAndPush: ->
    return @isAndPush.is(':checked')
