# Kasteroids
Asteroids using a server running on Docker/Kubernetes

## KasteroidsClient
An Unity client project that is responsible for sending inputs to the server

## KasteroidsServer
An Unity server project this is responsible for listening to inputs and updating the game/world state.

I am hosting the server as a docker container running on Ubuntu.
https://hub.docker.com/r/etdofresh/kasteroidsserver

## KasteroidsShared
A C# project that is supposed to be a share library that both Client and Server could use. I'm not sure that this project is long for this world. :p

## KasteroidsMatchMaker [Not there yet...]
A C# project that accepts incoming connections. Figures out which server (existing or creates new) for the player to join.
