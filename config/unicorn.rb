listen 3000, :tcp_nopush => false

stderr_path File.join(File.dirname(__FILE__), "/../log/unicorn.stderr.log")
stderr_path File.join(File.dirname(__FILE__), "/../log/unicorn.stdout.log")