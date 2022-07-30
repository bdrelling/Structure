#!/bin/bash

export DATABASE_URL=$(heroku config:get DATABASE_URL -a briandrelling-dev)