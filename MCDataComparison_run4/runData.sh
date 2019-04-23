#!/bin/bash

if [ -z ${1+x} ]; then echo "give a hld file name as argument"; exit; fi
./data_run4.x -t hld -f $1 -p 4_RUN/conf_trb3.xml -u userParams.json -i 4 -l 4_RUN/detectorSetupRun4.json 
