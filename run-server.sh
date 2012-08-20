#!/bin/bash

NODEMON=`which nodemon`
TARGET='src/app.coffee'
DIRECTORY='src'
DEVELOPMENT=1 $NODEMON --exitcrash -w "$DIRECTORY" "$TARGET"