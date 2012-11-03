#! /bin/bash

if [ "$JENKINS" ] 
then
    NODE="node-jenkins.json"
    CONFIG="./solo-jenkins.rb"
else
    NODE="node.json"
    CONFIG="./solo.rb"
fi

sudo chef-solo -c $CONFIG -j $NODE
exit