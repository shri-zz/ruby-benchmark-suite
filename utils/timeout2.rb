if(ARGV[0] != '-t')
 puts "format: -t secs, command arg1 arg2..."
 exit
end

require 'timeout'
begin
  Timeout::timeout(ARGV[1].to_i) {
	system(ARGV[2..-1].join(' '))
  }
rescue Timeout::Error
  puts 'timed out'
  
  # On Windows, Timeout::Error will be raised without killing the child process.
  # So we use taskkill to kill the current process and all child processes ("/T")
  # Note that the taskkill process is also a child process, but taskkill 
  # is able to kill the other child processes and print an error
  # message saying "The process cannot terminate itself."
  require 'rbconfig'
  if RbConfig::CONFIG['host_os'] =~ /mswin|mingw/
    `taskkill /F /T /PID #{Process.pid}`
  end
end
