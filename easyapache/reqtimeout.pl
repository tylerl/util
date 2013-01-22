#!/usr/bin/perl

# mod_reqtimeout installer for cPanel's EasyApache build system
# Created by Tyler Larson @tltech.com
# Run using "build" or "install" to either build a tar.gz module, 
# or alternately to simply install it locally.

use Archive::Tar;
use LWP::UserAgent;
use IO::Compress::Gzip qw(gzip) ;

# Location from where to download the current version of mod_reqtimeout
$DOWNLOAD_URL="https://raw.github.com/apache/httpd/2.2.x/modules/filters/mod_reqtimeout.c";

# Location where to install on cpanel servers
$CPANEL_DIR="/var/cpanel/easy/apache/custom_opt_mods";

sub usage() {
    print STDERR <<END;
$0 ( build | install )
 - build   -- builds a tar.gz installation package
 - install -- installs or updates the easyapache module locally
END
	exit(1);
}

$MODE=shift;
$MODE eq "build" or $MODE eq "install" or usage();

$MODE eq "install" and not ( -d $CPANEL_DIR ) and do {
	print STDERR "Install directory does not exist: $CPANEL_DIR\n";
	print STDERR "Is this a cpanel server? If not, then build, not install.\n";
	exit 1;
};

######
# Download latest version of the code
$ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 0 });
$resp = $ua->get($DOWNLOAD_URL);
$resp and $resp->is_success or die "Failed to download: [$DOWNLOAD_URL]";
$mod = $resp->decoded_content;

######
# Create the source code tar.gz
$pkg_tar = Archive::Tar->new;
$pkg_tar->add_data("mod_reqtimeout/mod_reqtimeout.c", $mod);
$pkg_data = $pkg_tar->write();
$pkg_gzip = "";
gzip \$pkg_data => \$pkg_gzip or die;

#######
# Create the installation tar.gz
$out_tar = Archive::Tar->new;
$out_tar->add_data("Cpanel/Easy/ModReqtimeout.pm.tar.gz",$pkg_gzip);
$out_tar->add_data("Cpanel/Easy/ModReqtimeout.pm",<<'END');
package Cpanel::Easy::ModReqtimout;
# Created by Tyler Larson
our $easyconfig = {
    'version' => '$Rev: 1 $',
    'name'    => 'mod_reqtimeout',
    'note'    => 'Apache mod_reqtimeout support',
    'url'     => 'http://httpd.apache.org/docs/trunk/mod/mod_reqtimeout.html',
    'src_cd2' => 'mod_reqtimeout',
    'hastargz' => 1,
    'step'    => {
        '0' => {
            'name'    => 'Compiling, installing, and activating',
            'command' => sub {
                my ($self) = @_;
                my ($rc, @msg) = $self->run_system_cmd_returnable( [ $self->_get_main_apxs_bin(), qw(-i -a -c mod_reqtimeout.c)] );
                if (!$rc) { $self->print_alert_color('red', q{apxs mod_reqtimeout.c failed}); }
                return ($rc, @msg);
            },            
        },
    },    
}; 
1;
END

if ( $MODE eq "build" ) {
	# we're just building the archive, so output it right here.
	$out_tar->write("custom_opt_mod-mod_reqtimeout.tar.gz",COMPRESS_GZIP);
	print "Built as: custom_opt_mod-mod_reqtimeout.tar.gz\n";
} else {
	# We're installing the module, so extract our archive to the appropriate dir
	chdir $CPANEL_DIR or die ("Failed chdir to $CPANEL_DIR");
	$out_tar->extract() or die "Failed to install.";
	print "Installed successfully.\n";
}
