#!/bin/bash
set -e

# Function to check if Postgres is ready
wait_for_postgres() {
    until psql -h "$HOST" -U "$USER" -c '\q'; do
        >&2 echo "Postgres is unavailable - sleeping"
        sleep 1
    done
    >&2 echo "Postgres is up - executing command"
}

# If the command starts with odoo, we want to run the custom logic
if [ "$1" = 'odoo' ]; then
    wait_for_postgres

    # Run Odoo with the correct user
    exec gosu odoo-user odoo "$@"
else
    # Otherwise, just run the command as is
    exec "$@"
fi