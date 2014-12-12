desc "Enter a pry console session with app loaded"
task :console => :config do
  binding.pry
end

task :config do
  $: << File.dirname(__FILE__)
  require 'app'
end

desc "Rebuild bootstrap CSS"
task :bootstrap do
  old_dir = Dir.getwd
  begin
    Dir.chdir File.join(File.dirname(__FILE__), 'vendor', 'bootstrap-3.3.1')
    pty_run 'grunt dist'
  ensure
    Dir.chdir old_dir
  end
end


def pty_run cmd
  require 'pty'
  begin
    PTY.spawn( cmd ) do |stdin, stdout, pid|
      begin
        stdin.each { |line| print line }
      rescue Errno::EIO
        # puts "Errno:EIO error, but this probably just means " +
        #       "that the process has finished giving output"
      end
    end
  rescue PTY::ChildExited
    puts "The child process exited!"
  end
end
