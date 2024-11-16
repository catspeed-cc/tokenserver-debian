# tokengenerator-debian

Dockerized token generator for catspeed fork, based on Debian

#### Due to technical reasons, this will only work for catspeed fork, found at https://github.com/catspeed-cc/invidious

The project was basically finished in ~12 hours for the anonymous token pre-generator. I am working on adding the user token pre-generator as well. Then I can rip the CPU intensive code out of the invidious code/container, and it will be siloed in it's own container here.

I suspect this will eventually include "token server" and you will be able to choose between one docker container pre-generating tokens, or a token server instance that you can set up multiple and have reverse proxy to multiple token servers with tokens being requested on the fly as users need them.

Planned features:
- Token pregeneration for users
- Token pregeneration for anon users
- Token server

Will make documentation, images and upload to dockerhub or other later.

**Why Debian?** Well the alpine image is so stripped down, I had issues with installing node and getting it to work even though I did in a different alpine image. So I chose my next favorite, Debian. From what I understand the size difference is probably ~200MB.

#### Project is in development. No release dates set. Please wait patiently :3c
