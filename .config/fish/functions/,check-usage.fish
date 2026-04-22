function ,check-usage
    history | grep $argv[1] | wc -l
end
