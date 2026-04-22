function test_exporter
    task load:db -- $argv[1].sql && task php:run-exporter -- $argv[1]
end
