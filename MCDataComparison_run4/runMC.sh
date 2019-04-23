#!/bin/bash

if [ -z ${1+x} ]; then
    echo "expected arguments: input_file_name "
    exit 
fi

./mc_run4.x -t mcGeant -f $1 -u userParams.json -l 4_RUN/detectorSetupRun4.json -i 4 
