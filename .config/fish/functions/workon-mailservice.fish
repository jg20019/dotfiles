function workon-mailservice
    echo "Starting consul"
    docker run -d --rm -p 8500:8500 -p 8600:8600/udp \
        --name=mailservice-consul consul:1.15.4 \
        agent -server -ui -node=server-1 -bootstrap-expect=1 -client=0.0.0.0

    echo "Starting postgres"
    docker volume create mailservice-postgres-volume
    docker run --rm --name mailservice-postgres \
        -v mailservice-postgres-volume:/var/lib/postgresql/data \
        -e POSTGRES_USER=postgres \
        -e POSTGRES_PASSWORD=P@ssw0rd \
        -p 5432:5432 \
        -d postgres:15.5

    echo "Starting RabbitMQ"
    docker run --rm -d --name mailservice-rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3-management

    echo Done
end
