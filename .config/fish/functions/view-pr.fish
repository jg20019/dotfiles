function view-pr
    git diff -p development..(git branch --show-current)
end
