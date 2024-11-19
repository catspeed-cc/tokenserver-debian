# tokenserver-debian

## Description

Dockerized token server for catspeed fork found at https://github.com/catspeed-cc/invidious - based on Debian

The project was basically finished in ~12 hours for the anonymous token pre-generator. Everything _was_ working, however something got buggered up and I cannot find the problem. So I've decided to move on to the token server and abandon the token pre-generator. You will still be pre-generating tokens though, because pulling them out of redis is the fastest way to get a response to the client.

I will also be moving the stats calculator here, to keep everything neat and tidy in this project, and also remove even more load off the invidious process/container. Eventually all that the invidious process/container will be doing is making redis calls.

Invidious has enough troubles, serving content in a timely manner, and reliably as it is - after all the current recommendation is to restart it hourly, and I've even had to minutely just to stop it eating CPU and memory after the sig-helper crashes. Spawning cpu-intensive processes from within invidious when invidious is expected to make a timely response to a client is a bad idea. Invidious should be dedicated to serving users video in a timely manner. Even slight delays are unacceptable to the client.

So far in testing, the load on the invidious process/container has been massively reduced, because I no longer use the invidious main process to generate tokens (which was a bad idea anyways)

Token server will be able to be set up behind a reverse proxy, and you will be able to have infinite number of token servers.

## Features

- Stats monitor (not started yet)
- Token generation (completed)
- Token server / API (in process)

#### Token server will be compatible with other forks, as long as you know how to program in the request and extraction of tokens from the response.

## Documentation

Will make documentation, images and upload to dockerhub or other later.

## FAQ

**Why Debian?** Well the alpine image is so stripped down, I had issues with installing node and getting it to work even though I did in a different alpine image. So I chose my next favorite, Debian. From what I understand the size difference is probably ~200MB.

#### Project is in development. No release dates set. Please wait patiently :3c

Debian + bash FTW

~ mooleshacat (invidious.catspeed.cc)

EOF
