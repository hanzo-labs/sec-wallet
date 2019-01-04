import Control from 'el-controls/src/controls/control'

import html from '../../../templates/controls/picker.pug'

export default class Picker extends Control
  tag: 'picker'
  html: html

  # default to something that will be visible
  _optionsHash: 'default'
  pickerOptions: {}
  value: ''

  options: ->
    pickerOptions = @pickerOptions
    if typeof pickerOptions == 'function'
      pickerOptions = pickerOptions()

    optionsHash = JSON.stringify pickerOptions

    if @_optionsHash != optionsHash
      @_optionsHash = optionsHash

    return pickerOptions

  isPicked: (id)->
    return id == @value

  pick: (id)->
    return ()=>
      @value = id

  getValue: ->
    return @value

  init: ->
    super arguments...

    for k, v of @pickerOptions
      @value = k
      break

Picker.register()


