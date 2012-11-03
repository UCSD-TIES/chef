#! /bin/bash

if [ "$JENKINS" ] 
then
    NODE="node-jenkins.json"
else
    NODE="node.json"
fi

sudo chef-solo -c ./solo.rb -j $NODE
exit