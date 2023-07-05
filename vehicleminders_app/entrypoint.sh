#!/bin/bash
set -e

rm -f /VehicleMinders/tmp/pids/server.pid

exec "$@"
