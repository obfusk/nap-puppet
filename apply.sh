#!/bin/bash

puppet apply --modulepath ./modules --verbose "$@"
