#!/usr/bin/perl -w
#
# Author: Jue Ruan <ruanjue@gmail.com>
#
use strict;

=pod
Transform <dbg>.[1/2/3].dot into GFA format. <dbg>.[1/2/3].dot is the assembly graph from wtdbg
TAG:
	gl: gap length
	rc: read count to support the link
	sq: sequence can be substr from <rd_name>_<FR>_<off>_<len>, F fwd, R rev, off is based on the fwd strand
=cut

while(<>){
	chomp;
	next unless(/^(N\d+)\s(->\s(N\d+)\s)?\[([^\]]+)\]$/);
	my $n1 = $1;
	my $n2 = $3;
	my $label = $4;
	if(defined $n2){
		if($label=~/label=\"(\S)(\S):(\d+):(\-?\d+)\"/){
			if($4 >= 0){
				print "L\t$n1\t$1\t$n2\t$2\t0S\tgl:i:$4\trc:i:$3\n";
			} else {
				print "L\t$n1\t$1\t$n2\t$2\t". (0 - $4) . "M\trc:i:$3\n";
			}
		} else {
			die("Bad format: $_");
		}
	} else {
		if($label=~/\{N\d+\s(\d+)\s\|\s(\S+)\s\|\s([FR])_(\d+)_(\d+)\}/){
			print "S\t$n1\t*\tLN:i:$5\tsq:Z:$2_$3_$4_$5\n"
		} else {
			die("Bad format: $_");
		}
	}
}

1;
