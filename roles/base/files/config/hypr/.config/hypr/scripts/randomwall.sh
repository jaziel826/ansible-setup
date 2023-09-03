#!/bin/bash

wall=~/.config/wall/
setrandom() {

/usr/bin/setrandom $wall

}

while true; do

setrandom

sleep 60m

done
