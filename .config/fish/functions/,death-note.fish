function ,death-note
    ps aux | fzf | awk '{print $2}' | xargs kill -9
end
