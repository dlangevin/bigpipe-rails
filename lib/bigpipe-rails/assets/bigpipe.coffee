# Bigpipe - singleton/factory for PageletResources and Pagelets
class Bigpipe
  # set up our instance variables to hold the CSS/JS PageletResources
  constructor : ()->
    @css = {}
    @js = {}
    @pagelets = []
  
  # add a Pagelet to the stack, the Pagelet takes care of its own loading
  add_pagelet : (data)=>
    @pagelets.push(new Pagelet(data))

  # some Pagelets will need the same css/js before initializing, make sure that
  # we only load each resource once
  get_resource : (file, type)=>
    if type == "css"
      @css[file] ?= new CssResource(file)
      return @css[file]
    else if type == "js"
      @js[file] ?= new JsResource(file)
      return @js[file]
       
# Load a resource
# Loading has 3 phases
# 0 - not on the page
# 1 - on the page but not finished loading
# 2 - loaded
class PageletResource
  # get the file name and set load_phase to 0 (not started)
  constructor : (file_name)->
    @load_phase = 0
    @file_name = file_name
  # if load_phase is 2, we have completed loading
  loaded : ()->
    @load_phase == 2
  # only call this once, we set load phase to 1 when the element is created
  # and add a listener to the element's 'ready' callback to set it to 2
  load : ()->
    return if @load_phase > 0
    @load_phase = 1
    # handled in the subclass
    this.create_element()
    @el.ready(()=>
      this.load_phase = 2
    )
    this
    
# concrete implementation for CSS
class CssResource extends PageletResource
  create_element : ()->
    @el = $j(document.createElement('link'))
    @el.attr('rel', 'stylesheet').attr('href', "#{@file_name}.css")
    @el

# concrete implementation for JS
class JsResource extends PageletResource
  create_element : ()->
    @el = $j(document.createElement('script'))
    @el.attr('type', 'text/javascript').attr('src', "#{@file_name}.js")
    @el
  
# a Pagelet is a composed of a container element, some HTML content and resources
# the order is as follows
# 1 - initialize Pagelet giving it the paths of its resources, its container, its content and any callbacks
# 2 - load all of the CSS, checking back every 20ms to see if the loading is complete
# 3 - put the HTML on the page
# 4 - load all of the JS, checking back every 20ms to see if the loading is complete
# 5 - call the on_load callback
class Pagelet
  # constructor data
  # - container - jQuery selector of the container to populate
  # - content - HTML content to put in the container
  # - css - Array of css files to load
  # - js - Array of js files to load
  # - append - Option to append the content to the container rather than replace its HTML
  constructor : (data)->
    @container = data.container
    @content = data.content
    @append = data.append || false
    @css_resources = []
    @js_resources = []
    @on_load = data.on_load ? ()->
    this.init_resources(data)
    this.load_css()
  # use Bigpipe's factory method to find or create the js and css resources
  init_resources : (data)->
    $j.each((data['css'] || []),(i, file)=>
      this.css_resources.push(window.Bigpipe.get_resource(file, 'css'))
    )
    $j.each((data['js'] || []),(i, file)=>
      this.js_resources.push(window.Bigpipe.get_resource(file, 'js'))
    )
  # first phase - load the css files
  load_css : ()->
    this.add_css()
    # keep trying every 20ms til the loading of the CSS is complete
    # TODO: this will lock up a browser if the CSS is never found - make sure to take care of that
    unless this.css_loaded()
      setTimeout(()=>
        this.load_css()
      , 20)
    else
      # once we've loaded the CSS, we move on to the HTML and JS
      this.add_html()
      this.load_js()
  
  # final phase - load the js 
  # TODO: maybe make this before the HTML and use on_load to initialize
  # listeners?
  load_js : ()->
    this.add_js()
    unless this.js_loaded()
      setTimeout(()=>
        this.load_js()
      ,20)
    else
      this.on_load()
  # check to seee if all of the css resources are loaded  
  css_loaded : ()->
    loaded = true
    $j.each(@css_resources, (i, resource)->
      loaded = (loaded && resource.loaded())
    )
    return loaded
  # check to see if all of the js resources are loaded
  js_loaded : ()->
    loaded = true
    $j.each(@js_resources, (i, resource)->
      loaded = (loaded && resource.loaded())
    )
    return loaded
  # add and load a js resource
  add_js : ()->
    $j.each(@js_resources, (i, resource)->
      resource.load()
    )
  # add and load a css resource
  add_css : ()->
    $j.each(@css_resources, (i, resource)->
      resource.load()
    )
  # add htmlt to the container - replacing or appending as appropriate
  add_html : ()->
    unless @append
      $j(@container).html(@content)
    else
      $j(@container).append(@content)

this.$j = jQuery.noConflict()
this.Bigpipe = new Bigpipe()
