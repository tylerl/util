easyapache
==========

These scripts (currently only one) add support for additional apache modules to
cPanel's [EasyApache][EA] build system.

* **cloudflare.pl**: adds support for [mod_cloudflare][cf]
* **reqtimeout.pl**: adds support for [mod_reqtimeout][rt]
* **rpaf.pl**: adds support for [mod_rpaf][rp]

To use the build script, just run it like this;


    $ perl cloudflare.pl install
    ## This method will install the easyapache component on the current server

    $ perl cloudflare.pl build
    ## This method will build a tar.gz package you can install elsewhere
    ## For what do do with it, see http://docs.cpanel.net/twiki/bin/view/EasyApache3/CustomMods
    
Once you've installed the EasyApache component, re-run the EasyApache build 
script, either through the WHM web interface or by running `/scripts/easyapache`
to complete the installation.

  [EA]: http://docs.cpanel.net/twiki/bin/view/EasyApache3/CustomMods
  [cf]: https://www.cloudflare.com/wiki/Log_Files
  [rt]: http://httpd.apache.org/docs/trunk/mod/mod_reqtimeout.html
  [rp]: http://www.stderr.net/apache/rpaf/

### But `mod_reqtimeout` is distributed with Apache! Why do I need this?

Yeah. It's pretty annoying that cPanel hasn't included support for `mod_reqtimeout` in the build system.
As soon as they start supporting it internally, `reqtimeout.pl` will become obsolete. You may be
able to speed this process by pestering the cPanel developers. Good luck!

### Why not just install the apache module directly?

While you could simply download the apache module directly and use `apxs` to install it,
if you do so your server will break the next time you use the EasyApache tool to update 
your Apache or PHP installation.  EasyApache starts out each time with a fresh, clean apache source tree. 
This means that any changes or modules you've built will be wiped out. By incorporating your 
module into the EasyApache build system, you guarantee that every time apache gets rebuilt, 
your module will be included.

Also, this mechanism is dramatically easier. Run this script to add "Mod CloudFlare" as a
prompt in your EasyApache build system. Enable it by building with the module selected, disable
it by building with it deselected. It couldn't be simpler.
