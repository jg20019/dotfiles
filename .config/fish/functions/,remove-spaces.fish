function ,remove-spaces
    mv $argv[1] (string replace -a " " "-" $argv[1] | string lower)
end
