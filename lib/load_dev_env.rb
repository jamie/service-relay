if File.exist?('./env')
  File.read('./env').each_line do |line|
    k,v = line.chomp.split('=', 2)
    ENV[k] = v if k
  end
end

