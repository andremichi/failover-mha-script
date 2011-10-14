#!/usr/bin/perl -w

### Author: Andre Michi
### e-mail: andremichi@gmail.com
### check_mha.pl - Script that checks if the MHA daemon is running

my $RC_OK=0;
my $RC_CRITICAL=2;
my $RC_UNKNOWN=3;
my $mha_config_file = "/etc/mha/cluster.conf";
my $check_failover_file = "/var/tmp/cluster.failover.complete";

my $cmd = `/usr/bin/masterha_check_status --conf=\"$mha_config_file\"`;

if($cmd =~ m/NOT_RUNNING/) {
	if (-e $check_failover_file) {
		print "[CRITICAL] - Service MHA not running - A failover has been done \n";
		exit $RC_CRITICAL;
	}else{
		print "[CRITICAL] - Service MHA not running - Please start the daemon \n"; 
	}
}elsif ($cmd =~ m/is running/) {
	print "[OK] - Service MHA running \n";
	exit $RC_OK;
}else{
	print "[Unknown] - Service MHA with unknown status \n";
	exit $RC_UNKNOWN;
}
