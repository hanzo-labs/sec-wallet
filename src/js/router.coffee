import store from 'akasha'

# most terrible router in the world
class Router
  onUpdate: ()->

  constructor: (title, page) ->
    if page
      @set title, page

    window.addEventListener 'popstate', =>
      @onUpdate()

  add: (title, page) ->
    history.pushState { title: title, page: page }, title, page
    @onUpdate()

  set: (title, page)->
    history.replaceState { title: title, page: page }, title, page
    @onUpdate()

  addFn: (title, page)->
    return () =>
      history.pushState { title: title, page: page }, title, page
      @onUpdate()

  setFn: (title, page)->
    return () =>
      history.replaceState { title: title, page: page }, title, page
      @onUpdate()

  get: ->
    state = history.state

    return {} if !state

    return {
      title: history.state.title
      page: history.state.page
    }

export default Router
