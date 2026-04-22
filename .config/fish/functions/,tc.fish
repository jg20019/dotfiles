function ,tc
    task -ls | fzf --multi --preview 'task --summary {}' | xargs task
end
