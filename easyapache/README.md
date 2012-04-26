easyapache
==========

These scripts (currently only one) add support for additional apache modules to
cPanel's [EasyApache][EA] build system.

* **cloudflare.pl**: adds support for [mod_cloudflare][cf]

To use the build script, just run it like this;


    $ perl cloudflare.pl install
    ## This method will install the easyapache component on the current server

    $ perl cloudflare.pl build
    ## This method will build a tar.gz package you can install elsewhere
    
Once you've installed the easyapache component, re-run the easyapache build 
script, either through the WHM web interface or by running `/scripts/easyapache`
to complete the installation.


  [EA]: http://docs.cpanel.net/twiki/bin/view/EasyApache3/CustomMods
  [cf]: https://www.cloudflare.com/wiki/Log_Files
