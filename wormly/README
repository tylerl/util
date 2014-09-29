Health reporting agent for use with [Wormly][2].

This is roughly the same as their own agent.php, only this one
is a stand-alone python script that runs a webserver using [Flask][1].

This was written for use on a server which doesn't have Apache and 
PHP installed, and where I didn't *want* to install either. 

To use, download the agent.php script for the server you want to 
install health monitoring on, and extract the password from that
script and insert it into this python version. Pick a port to run
your HTTP server on, and execute the script -- presumably as part of
the server startup sequence or something.

Prolly best to *not* run it as root. Not because there's anything
inherently unsafe about this program, but because taking on 
unnecessary risk is dumb.

  [1]: http://flask.pocoo.org/
  [2]: https://www.wormly.com/
