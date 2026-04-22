function xlsx-to-csv
    libreoffice --headless --convert-to csv --outdir . $argv[1]
end
