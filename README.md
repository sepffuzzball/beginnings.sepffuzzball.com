# [public site](https://beginnings.sepffuzzball.com/)

## About
This is a little Twine game to introduce the reader to my character Sepfy! They exist in many different worlds so it's nice to get a slight amount of backstory to understand just who Sepfy is.

## Info
This is built on [Twine](https://twinery.org/) using the Harlowe 3.3.9 StoryFormat using twee3 notation. Inside of the Dockerfile build it uses tweego to compile the story into an html file and then thrown in an nginx docker container. It's then pulled from ghcr via Flux.

Updates to the game should be autobuilt via Github Actions when modifying the Beginnings.twee file. Tweego is very picky about having the correct story format, so make sure that if you change the Harlowe version in the .twee file that you also update the format version ([Harlowe 3.3.9 Story Format](https://twine2.neocities.org/harlowe-3.3.9.js)).
