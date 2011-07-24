(function() {
  var BigPipe, CssResource, JsResource, Pagelet, PageletResource;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  BigPipe = (function() {
    function BigPipe() {
      this.get_resource = __bind(this.get_resource, this);
      this.add_pagelet = __bind(this.add_pagelet, this);      this.css = {};
      this.js = {};
      this.pagelets = [];
    }
    BigPipe.prototype.add_pagelet = function(data) {
      return this.pagelets.push(new Pagelet(data));
    };
    BigPipe.prototype.get_resource = function(file, type) {
      var _base, _base2, _ref, _ref2;
      if (type === "css") {
                if ((_ref = (_base = this.css)[file]) != null) {
          _ref;
        } else {
          _base[file] = new CssResource(file);
        };
        return this.css[file];
      } else if (type === "js") {
                if ((_ref2 = (_base2 = this.js)[file]) != null) {
          _ref2;
        } else {
          _base2[file] = new JsResource(file);
        };
        return this.js[file];
      }
    };
    return BigPipe;
  })();
  PageletResource = (function() {
    function PageletResource(file_name) {
      this.load_phase = 0;
      this.file_name = file_name;
    }
    PageletResource.prototype.loaded = function() {
      return this.load_phase === 2;
    };
    PageletResource.prototype.load = function() {
      if (this.load_phase > 0) {
        return;
      }
      this.load_phase = 1;
      this.create_element();
      this.el.ready(__bind(function() {
        return this.load_phase = 2;
      }, this));
      return this;
    };
    return PageletResource;
  })();
  CssResource = (function() {
    __extends(CssResource, PageletResource);
    function CssResource() {
      CssResource.__super__.constructor.apply(this, arguments);
    }
    CssResource.prototype.create_element = function() {
      this.el = $j(document.createElement('link'));
      this.el.attr('rel', 'stylesheet').attr('href', "" + this.file_name + ".css");
      return this.el;
    };
    return CssResource;
  })();
  JsResource = (function() {
    __extends(JsResource, PageletResource);
    function JsResource() {
      JsResource.__super__.constructor.apply(this, arguments);
    }
    JsResource.prototype.create_element = function() {
      this.el = $j(document.createElement('script'));
      this.el.attr('type', 'text/javascript').attr('src', "" + this.file_name + ".js");
      return this.el;
    };
    return JsResource;
  })();
  Pagelet = (function() {
    function Pagelet(data) {
      var _ref;
      this.container = data.container;
      this.content = data.content;
      this.append = data.append || false;
      this.css_resources = [];
      this.js_resources = [];
      this.on_load = (_ref = data.on_load) != null ? _ref : function() {};
      this.init_resources(data);
      this.load_css();
    }
    Pagelet.prototype.init_resources = function(data) {
      $j.each(data['css'] || [], __bind(function(i, file) {
        return this.css_resources.push(window.BigPipe.get_resource(file, 'css'));
      }, this));
      return $j.each(data['js'] || [], __bind(function(i, file) {
        return this.js_resources.push(window.BigPipe.get_resource(file, 'js'));
      }, this));
    };
    Pagelet.prototype.load_css = function() {
      this.add_css();
      if (!this.css_loaded()) {
        return setTimeout(__bind(function() {
          return this.load_css();
        }, this), 20);
      } else {
        this.add_html();
        return this.load_js();
      }
    };
    Pagelet.prototype.load_js = function() {
      this.add_js();
      if (!this.js_loaded()) {
        return setTimeout(__bind(function() {
          return this.load_js();
        }, this), 20);
      } else {
        return this.on_load();
      }
    };
    Pagelet.prototype.css_loaded = function() {
      var loaded;
      loaded = true;
      $j.each(this.css_resources, function(i, resource) {
        return loaded = loaded && resource.loaded();
      });
      return loaded;
    };
    Pagelet.prototype.js_loaded = function() {
      var loaded;
      loaded = true;
      $j.each(this.js_resources, function(i, resource) {
        return loaded = loaded && resource.loaded();
      });
      return loaded;
    };
    Pagelet.prototype.add_js = function() {
      return $j.each(this.js_resources, function(i, resource) {
        return resource.load();
      });
    };
    Pagelet.prototype.add_css = function() {
      return $j.each(this.css_resources, function(i, resource) {
        return resource.load();
      });
    };
    Pagelet.prototype.add_html = function() {
      if (!this.append) {
        return $j(this.container).html(this.content);
      } else {
        return $j(this.container).append(this.content);
      }
    };
    return Pagelet;
  })();
  this.$j = jQuery.noConflict();
  this.BigPipe = new BigPipe();
}).call(this);
