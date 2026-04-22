function chown-and-rm
sudo chown -R $USER:$USER $argv[1]
rm -rfi $argv[1]
end
