#!/bin/bash

#cleanup if required
./cleanup.sh
docker-compose run --name blog --rm -p4000:3000 blog
