# FriendlyBot Plan

## Wandering
* new elixir project
  * use roombex
* install firmware update to get basic dead reckoning
* add roombex support for dead reckoning
  * reset origin by hitting a button on the top of the roomba
* add a force vector field that encourages it to stay in a given radius from the origin
* avoid (but don't record) obstacles since they will mostly be people's feet
* accept some signals from the ruby code
  * stop wandering so I can focus
  * play a little song
  * start wandering again

## Face Finder

* When you see a face pause driving (signal to wanderer)
* Try to "look" at the face (center the frame)
* If the face is 50% of the frame take the picture
* Set a timeout (no more pictures for 10 seconds)
* "Look away" from the face so they know we are done
* Play a song (signal to wanderer)
* Continue wandering (signal to wanderer)

With the selected image

* Setup a fixed size Lifeguard pool
* Enqueue the job
  * send to Google API
  * crop the image to just the face
    * draw bounding rect around the boundingPoly
  * select most likely sentiment
  * select phrase based on sentiment
    * account for a no sentiment case
  * compose a tweet with the cropped image and the selected phrase
    * @mwrcbot
