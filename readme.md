## Introduction

set up DMZ (demilitarized zone) for ssh login.

Alpha version.

## How to setup

1. setup docker-sshdmz on your server / home server.

2. block incoming traffic on port 22 by using cloud provider's security group.

3. later on, ssh to docker-dmz, and then ssh to host.docker.internal:22 to connect to your real server.

## Advantage:

1. docker-sshdmz contains security features, and can be easily configured. (I hope)

2. ehmmm, that's it ?

## Disadvantage:

1. the program takes extra resources of course.

2. restarting docker services may disconnect the current ssh session.

3. in case docker service failed, you have to go to your cloud provider, modify inbound rules for port 22, reconnect to server via old ssh, and do the whole thing again.

## build

1. run setup.sh

2. build dockerfile and save your password

## run

better use host network
