#!/usr/bin/perl -w

#### Author: André Michi 
#### E-mail: andremichi@gmail.com
#### Script: master_ip_failover.pl
#### Description: A short script to change an virtual IP on a MySQL replication environment.
#### This script is invoked by MHA(MHA is automating master failover and slave promotion within short (usually 10-30 seconds) downtime) after a master failover.
#### MHA Project Page: http://code.google.com/p/mysql-master-ha/ 

use Getopt::Long;
use Switch;

### MHA parameters
my $orig_master_host = '' ; # Dead master_host
my $new_master_host = '' ;  # New master's hostname
my $command = '';
my $ssh_user = '';
my $orig_master_ip = '';
my $orig_master_port = '';
my $new_master_ip = '';
my $new_master_port = '';

# My variables
my $vip = 'your_virtual_ip';  # Virtual IP 
my $key = "your_key"; 
my $ssh_start_vif = "/sbin/ifconfig your_parameters_to_enable_a_vif";
my $ssh_stop_vif = "/sbin/ifconfig your_parameters_to_disable_a_vif";


# MHA send all this variables, but I only needed two: orig_master_host and new_master_host
GetOptions ('orig_master_host=s' => \$orig_master_host,
            'new_master_host=s' => \$new_master_host,
            'command=s' => \$command,
            'ssh_user=s' => \$ssh_user,
            'orig_master_ip=s' => \$orig_master_ip,
            'orig_master_port=s' => \$orig_master_port,
            'new_master_ip=s' => \$new_master_ip,
            'new_master_port=s' => \$new_master_port
            );

# MHA makes a check to see if the master_failover_script is OK
switch($command) {
    case "status" {
        print "Checking the Status of the script.. OK \n"; 
        exit 0;
    };
    case "start" {
        print "Enabling the VIP - $vip on the new master - $new_master_host \n";
        &start_vif();
    };
    case m?stop*? {
        print "Disabling the VIP on old master: $orig_master_host \n";
        &stop_vif();
    }
}
# A simple system call that enable the VIP on the new master 
sub start_vif() {
    `ssh $ssh_user\@$new_master_host \" $ssh_start_vif \"`;
}
# A simple system call that disable the VIP on the old_master
sub stop_vif() {
    `ssh $ssh_user\@$orig_master_host \" $ssh_stop_vif \"`;
}

#EOF
