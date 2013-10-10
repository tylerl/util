#!/usr/bin/perl

# mod_rpaf installer for cPanel's EasyApache build system
# Created by Tyler Larson @tltech.com
# Run using "build" or "install" to either build a tar.gz module, 
# or alternately to simply install it locally.
#
# Note that this file contains *ONLY* the Apache 2 version of mod_rpaf
# If you're using Apache 1.x, then don't use this script

use Archive::Tar;
use IO::Compress::Gzip qw(gzip) ;
use IO::Uncompress::Gunzip qw(gunzip) ;
use MIME::Base64 qw(decode_base64) ;

# Location where to install on cpanel servers
$CPANEL_DIR="/var/cpanel/easy/apache/custom_opt_mods";

sub usage() {
    print STDERR <<END;
$0 ( build | install )
 - build   -- builds a tar.gz installation package
 - install -- installs or updates the easyapache module locally

IMPORTANT: This script only contains the Apache 2.x verison of mod_rpaf. If
  you're running Apache 1.x, then don't use this script.
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
# gzip'ed mod_rpaf-2.0.c version 0.6 from:
#   http://www.stderr.net/apache/rpaf/download/mod_rpaf-0.6.tar.gz
$mod_gzipped = <<END;
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
END
$mod_gzipped = decode_base64($mod_gzipped);
$mod_unzipped = "";
gunzip \$mod_gzipped => \$mod_unzipped or die;


######
# Create the source code tar.gz
$pkg_tar = Archive::Tar->new;
$pkg_tar->add_data("mod_rpaf/mod_rpaf.c", $mod_unzipped);
$pkg_data = $pkg_tar->write();
$pkg_gzip = "";
gzip \$pkg_data => \$pkg_gzip or die;

#######
# Create the installation tar.gz

$out_tar = Archive::Tar->new;
$out_tar->add_data("Cpanel/Easy/ModRpaf.pm.tar.gz",$pkg_gzip);
$out_tar->add_data("Cpanel/Easy/ModRpaf.pm",<<'END');
package Cpanel::Easy::ModRpaf;
# Created by Tyler Larson 
our $easyconfig = {
    'version' => '$Rev: 1 $',
    'name'    => 'Mod Rpaf',
    'note'    => 'Reverse-Proxy Add Forward module',
    'url'     => 'http://www.stderr.net/apache/rpaf/',
    'src_cd2' => 'mod_rpaf',
    'hastargz' => 1,
    'step'    => {
        '0' => {
            'name'    => 'Compiling, installing, and activating',
            'command' => sub {
                my ($self) = @_;
                my ($rc, @msg) = $self->run_system_cmd_returnable( [ $self->_get_main_apxs_bin(), qw(-i -a -c mod_rpaf.c)] );
                if (!$rc) { $self->print_alert_color('red', q{apxs mod_rpaf.c failed}); }
                return ($rc, @msg);
            },            
        },
    },    
}; 
1;
END

if ( $MODE eq "build" ) {
	# we're just building the archive, so output it right here.
	$out_tar->write("custom_opt_mod-mod_rpaf.tar.gz",COMPRESS_GZIP);
	print "Built as: custom_opt_mod-mod_rpaf.tar.gz\n";
} else {
	# We're installing the module, so extract our archive to the appropriate dir
	chdir $CPANEL_DIR or die ("Failed chdir to $CPANEL_DIR");
	$out_tar->extract() or die "Failed to install.";
	print "Installed successfully.\n";
}
