# tokenserver-debian

## Github notice:

I am happy to announce github has restored my account :3c thank you GitHub for responding :)

## Description

Dockerized token server for catspeed fork found at https://github.com/catspeed-cc/invidious - based on Debian

Tokenserver pre-generates and stores tokens in redis cache, allowing you to make requests to an API to get the tokens instantaneously. It is primarily designed to be used with catspeed-cc/invidious fork. Tokenserver can store many tokens and serve them randomly. Tokenserver utilizes https://github.com/catspeed-cc/youtube-trusted-session-generator a fork of https://github.com/iv-org/youtube-trusted-session-generator .

I will also be moving the stats calculator here, to keep everything neat and tidy in this project, and remove even more load off the invidious process/container. Eventually all that the invidious process/container will be doing is making redis calls.

Tokenserver will be able to be set up behind a reverse proxy, and you will be able to have infinite number of token servers. The beautiful thing about this is the token data is only 350-500 bytes, meaning this can be set up on a relatively low bandwidth connection. I personally have only 10Mbit/sec upload, but it can handle lots at 500 bytes per request. Enough I suspect that it should sustain the catspeed invidious instance with high traffic. Worst case I can spin up a VPS with Vultr to take some load as well.

Tokens must be generated from same VPN and/or IP address as the invidious instance (or other application needing tokens)

Currently the api requires a trailing slash (ex. https://tokenserver.catspeed.cc/api/v1-00/get_tokens/) which is not a big deal, but I will try and fix this. Real API endpoint would not have a trailing slash. It's just some nginx configuration I have to work out.

#### Token server will be compatible with other forks, as long as you know how to program in the API request and extraction of tokens from the JSON response.

## Features

- Token generation
- Redis cache
- Token server / API
- Stats monitor (not started yet)
- Arm64 / Aarch64 image for raspi (not started yet)
- Catspeed fork integration (in testing)

## Docker tags
- catspeedcc/tokenserver-debian:latest - tag for latest version, can include minor version bumps (Ex. v0.50 -> v0.51)
- catspeedcc/tokenserver-debian:stable - tag for stable version, only includes major version bumps (Ex. v1.00 -> v2.00 - COMING SOON!)
- catspeedcc/tokenserver-debian:v0.54 - swap generators, additional docker service
- catspeedcc/tokenserver-debian:v0.53 - revert back to submodules.
- catspeedcc/tokenserver-debian:v0.52 - fixed gluetun - added sleep for gluetun init
- catspeedcc/tokenserver-debian:v0.51 - fixed JSON output
- catspeedcc/tokenserver-debian:v0.50 - initial image

## Releases

- v0.54 is now released. You can find it on the releases/tags page. Swapped YunzheZJU/youtube-po-token-generator for iv-org/youtube-trusted-session-generator. Added additional docker-compose service.

I have added submodules back.

**Note:** gluetun has been included in the example. Tokens must be generated from the same IP that you are accessing content from. In this case, we show example for gluetun because catspeed fork uses gluetun. You still have to select the proper server. If you are using catspeed fork, it has a better example in that repository.

## Dockerhub notes

Even if you use the dockerhub image, you still require the git repository:
```
git clone https://github.com/catspeed-cc/tokenserver-debian
```
This is due to the volumes linking to the token-data/ directory which you need to store data.

## Documentation

#### Installation

- ```git clone https://github.com/catspeed-cc/tokenserver-debian```
- ```cd tokenserver-debian```
- ```cp docker-compose.example.yml docker-compose.yml```
- edit the docker-compose.yml file to your liking
- ```docker-compose up -d```

For now you get very basic documentation, until I have the time to move it to the wiki and make it better.

## Support

Currently there is no support. I will start providing support once catspeed fork is integrated and working.

## FAQ

**Why Debian?** Well the alpine image is so stripped down, I had issues with installing node and getting it to work even though I did in a different alpine image. So I chose my next favorite, Debian. From what I understand the size difference is probably ~200MB.

#### Project is in development. No release dates set. Please wait patiently :3c

## Thanks
I deeply respect and appreciate the help from the following:
- unixfox 🦊
- samantazfox 🦊
- Fijxu my mentor
- syeopite
- techmetx11
- YunzheZJU
- [crystal lang matrix](https://matrix.to/#/#crystal-lang_crystal:gitter.im)
- anyone who's been waiting patiently

Invidious can be a real awesome community that encourages learning. Do not be discouraged, ever, by anyone. You can do it :3c

RIP my lesha kitty 2024 😭 your neighbourhood is owned by moo cat 🙀 

~ mooleshacat (invidious.catspeed.cc)

Debian + bash FTW

EOF
