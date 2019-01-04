import Control from 'el-controls/src/controls/control'
import $ from 'zepto-modules/_min'

import html from '../../../templates/controls/webcam-picture.pug'

navigator.getUserMedia  = navigator.getUserMedia ||
                          navigator.webkitGetUserMedia ||
                          navigator.mozGetUserMedia ||
                          navigator.msGetUserMedia

video = null
videoStream = null
track = null

export default class WebcamPicture extends Control
  tag: 'webcam-picture'
  html: html
  value: ''
  showVideo: false
  enableOpenCamera: true #delay for toggle
  resizeRatio: 2

  # default to something that will be visible
  getValue: ->
    return @value

  init: ->
    super arguments...

    @on 'updated', =>
      if !@value && !@showVideo
        @value = @input.ref.get(@input.name)

        img = document.createElement 'img'
        img.src = @value

        $img = $(img)

        $canvas = $(@root).find 'canvas'
        canvas = $canvas[0]
        ctx = canvas.getContext '2d'
        ctx.drawImage img, 0, 0, $img.width(), $img.height()

  openCamera: ->
    return if !@enableOpenCamera

    if !video
      video = document.createElement 'video'
      video.setAttribute 'autoplay',true
      video.setAttribute 'playsinline', true

      if navigator.mediaDevices?
        navigator.mediaDevices.getUserMedia
          video:
            width:
              min: 640
              max: 1280
            frameRate:
              max: 15
          audio: false
        .then (stream)=>
          video.srcObject = stream
          track = stream.getTracks()[0]
        .catch (e)->
          console.error('Rejected!', e)
      else
        navigator.getUserMedia
          video: true,
          audio: false
        .then (stream)=>
          video.srcObject = stream
          track = stream.getTracks()[0]
        .catch (e)->
          console.error('Rejected!', e)

    @showVideo = true
    @root.appendChild video
    @scheduleUpdate()

  snapshot: ->
    $canvas = $(@root).find 'canvas'
    $video = $(video)
    width  = $video.width() / @resizeRatio
    height = $video.height() / @resizeRatio
    $canvas.attr 'width', '' + width + 'px'
    $canvas.attr 'height', '' + height + 'px'

    canvas = $canvas[0]
    ctx = canvas.getContext '2d'
    ctx.drawImage video, 0, 0, width, height
    @value = canvas.toDataURL 'image/jpeg', 0.8
    @scheduleUpdate()

  retry: ->
    oldVideo = video
    track.stop()
    video=null
    @openCamera()

    setTimeout =>
      @root.removeChild oldVideo
    , 600

    @value = ''
    @scheduleUpdate()

  closeCamera: ->
    @root.removeChild video
    track.stop()
    video=null
    @showVideo = false
    @enableOpenCamera = false
    setTimeout =>
      @enableOpenCamera = true
      @scheduleUpdate()
    , 600
    @change()
    @scheduleUpdate()

WebcamPicture.register()


