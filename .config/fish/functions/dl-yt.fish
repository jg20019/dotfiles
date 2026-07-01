function dl-yt

yt-dlp --remote-components ejs:npm -t mp3 $argv[1] -o $argv[2];
end
