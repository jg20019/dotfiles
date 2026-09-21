function ,tc -d "fuzzy find tasks"
    task -ls | fzf --multi --preview 'task --summary {}' | xargs task
end
