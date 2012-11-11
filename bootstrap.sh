#! /bin/bash

if test ! $(which chef-solo)
then
    sudo true && curl -L https://www.opscode.com/chef/install.sh | sudo bash
fi

if [ "$JENKINS" ] 
then
    NODE="node-jenkins.json"
    CONFIG="/home/ubuntu/chef/solo-aws.rb"
elif [ "$ELASTIC_SEARCH" ]
then
    NODE="node-es.json"
    CONFIG="/home/ubuntu/chef/solo-aws.rb"
else
    NODE="node.json"
    CONFIG="./solo.rb"
fi

sudo chef-solo -c $CONFIG -j $NODE
exit