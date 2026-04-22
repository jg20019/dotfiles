function ,contrib
git log --author="John Gibson" --no-merges --format="%s" | sed 's/^\([A-Z]\+-[0-9]\+\).*/\1/' | sort | uniq
end
