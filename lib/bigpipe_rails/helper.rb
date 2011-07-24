module BigpipeRails
  module Helper
    extend ActiveSupport::Concern
    
    module InstanceMethods
      # helper method to put Bigpipe on the page
      def bigpipe(container, opts = {}, &block)
        @bigpipe_js = []
        @bigpipe_css = []
        opts[:append] ||= false
        opts[:container] = container
        self.bigpipes << [opts, block]
      end
      # accessor 
      def bigpipes
        @bigpipes ||= []
      end
      # render the collection
      def render_bigpipe
        @bigpipes.each do |pipe|
          opts, block = pipe
          # we actually run the block here - 
          # TODO: use em-synchrony and/or our own Fiber implementation
          opts[:content] = escape_javascript(capture(&block))
          data = capture do
            javascript_tag do
              %Q{BigPipe.add_pagelet(#{opts.to_json});}
            end
          end
          self.push(data)
        end
        ""
      end
    end
  end
end