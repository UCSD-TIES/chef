Running `vagrant provision` from the `whwn` repository will automatically provision these. 

If you wish to provision a stand-alone machine, run the following command frmo within this folder:

`sudo chef-solo -c solo.rb -j node.json`
