function show-listeners
netstat -anpe | grep $argv[1] | grep "LISTEN"
end
