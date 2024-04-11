#!/usr/bin/perl
use strict;
use warnings;

my $REGEXP = shift || die "no email-adress given (regexp-style, e.g. bl.*\@yahoo.com)!";

my @data = qx</usr/sbin/postqueue -p>;
my %Q;
my $queue_id;

for (@data) {
    if (/^(\w+)(\*|\!)?\s/) {
        $queue_id = $1;
    }
    if ($queue_id && /$REGEXP/i) {
        $Q{$queue_id} = 1;
        $queue_id = "";
    }
}

open(my $POSTSUPER, "|postsuper -d -") || die "couldn't open postsuper";

foreach (keys %Q) {
    print $POSTSUPER "$_\n";
}
close($POSTSUPER);
