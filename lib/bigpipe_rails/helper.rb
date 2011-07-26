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
          opts[:content] = capture(&block)
          # TODO: we are re-escaping here for some reason - should be able to use javascript_tag
          # helper, need to see why it doesn't work
          data = %Q{
            <script type="text/javascript">
              //<![CDATA[
                Bigpipe.add_pagelet(#{opts.to_json});
              //]]>
            </script>
          }
          self.output_buffer.safe_concat(data)
          true
        end
        ""
      end
    end
  end
end