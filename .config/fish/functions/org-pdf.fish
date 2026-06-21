function org-pdf
 
pandoc -s -f org -t pdf $argv[1] -o (string replace ".org" ".pdf" $argv[1]);
end
