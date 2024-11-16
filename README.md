# tokengenerator-debian

Dockerized token generator for catspeed fork, based on Debian

#### Due to technical reasons, token pre-generation will only work for catspeed fork, found at https://github.com/catspeed-cc/invidious

The project was basically finished in ~12 hours for the anonymous token pre-generator. I am working on adding the user token pre-generator as well. Then I can rip the CPU intensive code out of the invidious code/container, and it will be siloed in it's own container here. This should reduce the impact that the cpu-intensive token generation has on the invidious process/container.

I will also be moving the stats calculator here, to keep everything neat and tidy in this project, and also remove even more load off the invidious process/container. Eventually all that the invidious process/container will be doing is making redis calls.

Invidious has enough troubles, serving content in a timely manner, and reliably as it is - after all the current recommendation is to restart it hourly, and I've even had to minutely just to stop it eating CPU and memory after the sig-helper crashes. Spawning cpu-intensive processes from within invidious when invidious is expected to make a timely response to a client is a bad idea. Invidious should be dedicated to serving users video in a timely manner. Even slight delays are unacceptable to the client.

So far in testing, the load on the invidious process/container has been massively reduced, because I no longer use the invidious main process to generate tokens (which was a bad idea anyways)

I suspect this will eventually include "token server" and you will be able to choose between one docker container pre-generating tokens, or a token server instance that you can set up multiple and have reverse proxy to multiple token servers with tokens being requested on the fly as users need them.

#### Token server will be compatible with other forks, as long as you know how to program in the request and extraction of tokens from the response.

Planned features:
- Token pregeneration for users (in process)
- Token pregeneration for anon users (complete)
- Stats monitor (not started yet)
- Token server (last on the list)

Will make documentation, images and upload to dockerhub or other later.

**Why Debian?** Well the alpine image is so stripped down, I had issues with installing node and getting it to work even though I did in a different alpine image. So I chose my next favorite, Debian. From what I understand the size difference is probably ~200MB.

#### Project is in development. No release dates set. Please wait patiently :3c

Debian + bash FTW

~ mooleshacat (invidious.catspeed.cc)