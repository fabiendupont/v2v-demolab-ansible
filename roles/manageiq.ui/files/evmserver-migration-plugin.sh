#!/bin/bash

su - miq -c "cd /home/miq/manageiq-ui-classic/ ; NODE_ENV=development ./node_modules/.bin/webpack-dev-server --config config/webpack/development.js"
