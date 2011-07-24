module BigpipeRails
  module Helper
    # helper method to put Bigpipe on the page
    def bigpipe(container, opts = {}, &block)
      @bigpipe_js = []
      @bigpipe_css = []
      opts[:append] ||= false
      opts[:container] = container
      content = escape_javascript(capture(&block))
      data = %Q{
        <script type="text/javascript">
          BigPipe.add_pagelet(#{opts.to_json});
        </script>
      }
      push(data)
    end
  end
end