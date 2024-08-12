if [ "$NICK_OS" = "darwin" ]; then
    function postgres-darwin {
        if [ ! $1 ]; then
            echo "required command: <list/start/stop/restart/shell>"
        elif [ "$1" = "list" ]; then
            brew services
        elif [ "$1" = "start" ]; then
            brew services $1 postgresql
        elif [ "$1" = "stop" ]; then
            brew services $1 postgresql
        elif [ "$1" = "restart" ]; then
            brew services $1 postgresql
        elif [ "$1" = "shell" ]; then
            psql -d postgres
        else
            echo "required command: <list/start/stop/restart/shell>"
        fi
    }
fi
