### For alpha testing see the [alpha branch](https://github.com/LizenzFass78851/ubuntukvm/tree/alpha)


- the project is broken and i am unable to fix this project and build it stable for general use
- If anyone can fork this project and make it something better, I'd be grateful.
----
# ubuntukvm
A way to run windows as a virtual machine in docker under linux

## It currently only works if the following conditions are met:
- ubuntu 18.04 as host operating system (not successfully tested on newer ubuntu versions)
- the host system must have activated the virtualization technology of the cpu (e.g. intel-vt).
- at least 4 gb ram if only this docker container is running. on systems that run more than that, 8 gb of ram is recommended
- between 32 and 64 gb of storage space
- docker including docker-compose installed

## just enter the following command to run it:
````
git clone https://github.com/LizenzFass78851/ubuntukvm
cd ubuntukvm
docker-compose up -d
````

### important
- do not run "startup.sh" on the host operating system

### based on the idea under the reference
- [medium.com/axon-technologies](https://medium.com/axon-technologies/installing-a-windows-virtual-machine-in-a-linux-docker-container-c78e4c3f9ba1)
