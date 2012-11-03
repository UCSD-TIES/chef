#! /bin/bash

if [ "$JENKINS" ] then
    NODE="node.json"
else
    NODE="node-jenkins.json"
fi

sudo chef-solo -c ./solo.rb -j $NODE
exit