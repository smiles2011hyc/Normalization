#!/usr/bin/env perl
use warnings;
use strict;

if(@ARGV<2) {
    die "usage: perl cat_highexp_files.pl <sample id> <loc> [option]

where:
<sample id> 
<loc> is the path to the sample directories

option:
 -stranded: set this if your data are strand-specific.

 -u  :  set this if you want to return only unique mappers, otherwise by default
        it will return both unique and non-unique mappers.

 -nu :  set this if you want to return only non-unique mappers, otherwise by default
        it will return both unique and non-unique mappers.


";
}
my $NU = "true";
my $U = "true";
my $numargs = 0;
my $stranded = "false";
for(my$i=2; $i<@ARGV; $i++) {
    my $option_found = "false";
    if($ARGV[$i] eq '-stranded') {
	$option_found = "true";
	$stranded = "true";
    }
    if($ARGV[$i] eq '-nu') {
	$U = "false";
	$numargs++;
	$option_found = "true";
    }
    if($ARGV[$i] eq '-u') {
	$NU = "false";
	$numargs++;
	$option_found = "true";
    }
    if($option_found eq "false") {
	die "option \"$ARGV[$i]\" was not recognized.\n";
    }
}
if($numargs > 1) {
    die "you cannot specify both -u and -nu, it will output both unique
and non-unique by default so if that's what you want don't use either arg
-u or -nu.
";
}


my $LOC = $ARGV[1];
my $samfilename = $ARGV[2];
my @fields = split("/", $LOC);
my $last_dir = $fields[@fields-1];
my $loc_study = $LOC;
$loc_study =~ s/$last_dir//;

my %READ_HASH;
my $id = $ARGV[0];
chomp($id);
if ($U eq "true"){
    my ($outEx, $outInt, $dir, $outEx_a, $outInt_a, $dir_a);
    if ($stranded eq "false"){
	$outEx = "$LOC/$id/EIJ/Unique/$id.filtered_u_exonmappers.highexp_shuf_norm.sam";
	$outInt = "$LOC/$id/EIJ/Unique/$id.filtered_u_intronmappers.highexp_shuf_norm.sam";
	$dir = "$LOC/$id/EIJ/Unique";
    }
    if ($stranded eq "true"){
	$outEx = "$LOC/$id/EIJ/Unique/sense/$id.filtered_u_exonmappers.highexp_shuf_norm.sam";
        $outInt = "$LOC/$id/EIJ/Unique/sense/$id.filtered_u_intronmappers.highexp_shuf_norm.sam";
        $dir = "$LOC/$id/EIJ/Unique/sense/";
	$outEx_a = "$LOC/$id/EIJ/Unique/antisense/$id.filtered_u_exonmappers.highexp_shuf_norm.sam";
        $outInt_a = "$LOC/$id/EIJ/Unique/antisense/$id.filtered_u_intronmappers.highexp_shuf_norm.sam";
        $dir_a = "$LOC/$id/EIJ/Unique/antisense/";
    }
    my @ex = glob("$dir/*exonmappers*.highexp.sam");
    if (@ex > 0){
	open(OUT, ">$outEx") or die;
	%READ_HASH=();
	foreach my $file (@ex){
	    open(FILE, $file) or die "cannot find $file file\n";
	    while(my $line = <FILE>){
		chomp($line);
		if ($line =~ /^@/){
		    next;
		}
		my @a = split (/\t/, $line);
		my $readname = $a[0];
		$readname =~ s/[^A-Za-z0-9 ]//g;
		my $chr = $a[2];
		my ($HI_tag, $IH_tag);
		if ($line =~ /(N|I)H:i:(\d+)/){
		    $line =~ /(N|I)H:i:(\d+)/;
		    $IH_tag = $2;
		}
		if ($line =~ /HI:i:(\d+)/){
		    $line =~ /HI:i:(\d+)/;
		    $HI_tag = $1;
		}
		my $for_hash = "$readname:$IH_tag:$HI_tag";
		if (exists $READ_HASH{$chr}{$for_hash}){
		    next;
		}
		else{
		    print OUT "$line\n";
		    $READ_HASH{$chr}{$for_hash} = 1;
		}
	    }
	    close(FILE);
	}
	close(OUT);
    }
    my @int = glob("$dir/*intronmappers*.highexp.sam");
    if (@int > 0){
	open(OUT, ">$outInt") or die;
	%READ_HASH=();
	foreach my $file (@int){
	    open(FILE, $file) or die "cannot find $file file\n";
	    while(my $line = <FILE>){
		chomp($line);
		if ($line =~ /^@/){
		    next;
		}
		my @a = split (/\t/, $line);
		my $readname = $a[0];
		$readname =~ s/[^A-Za-z0-9 ]//g;
		my $chr = $a[2];
		my ($HI_tag, $IH_tag);
		if ($line =~ /(N|I)H:i:(\d+)/){
		    $line =~ /(N|I)H:i:(\d+)/;
		    $IH_tag = $2;
		}
		if ($line =~ /HI:i:(\d+)/){
		    $line =~ /HI:i:(\d+)/;
		    $HI_tag = $1;
		}
		my $for_hash = "$readname:$IH_tag:$HI_tag";
		if (exists $READ_HASH{$chr}{$for_hash}){
		    next;
		}
		else{
		    print OUT "$line\n";
		    $READ_HASH{$chr}{$for_hash} = 1;
		}
	    }
	    close(FILE);
	}
	close(OUT);
    }
    if ($stranded eq "true"){
	my @ex = glob("$dir_a/*exonmappers*.highexp.sam");
	if (@ex > 0){
	    open(OUT, ">$outEx_a") or die;
	    %READ_HASH=();
	    foreach my $file (@ex){
		open(FILE, $file) or die "cannot find $file file\n";
		while(my $line = <FILE>){
		    chomp($line);
		    if ($line =~ /^@/){
			next;
		    }
		    my @a = split (/\t/, $line);
		    my $readname = $a[0];
		    $readname =~ s/[^A-Za-z0-9 ]//g;
		    my $chr = $a[2];
		    my ($HI_tag, $IH_tag);
		    if ($line =~ /(N|I)H:i:(\d+)/){
			$line =~ /(N|I)H:i:(\d+)/;
			$IH_tag = $2;
		    }
		    if ($line =~ /HI:i:(\d+)/){
			$line =~ /HI:i:(\d+)/;
			$HI_tag = $1;
		    }
		    my $for_hash = "$readname:$IH_tag:$HI_tag";
		    if (exists $READ_HASH{$chr}{$for_hash}){
			next;
		    }
		    else{
			print OUT "$line\n";
			$READ_HASH{$chr}{$for_hash} = 1;
		    }
		}
		close(FILE);
	    }
	    close(OUT);
	}
	my @int = glob("$dir_a/*intronmappers*.highexp.sam");
	if (@int > 0){
	    open(OUT, ">$outInt_a") or die;
	    %READ_HASH=();
	    foreach my $file (@int){
		open(FILE, $file) or die "cannot find $file file\n";
		while(my $line = <FILE>){
		    chomp($line);
		    if ($line =~ /^@/){
			next;
		    }
		    my @a = split (/\t/, $line);
		    my $readname = $a[0];
		    $readname =~ s/[^A-Za-z0-9 ]//g;
		    my $chr = $a[2];
		    my ($HI_tag, $IH_tag);
		    if ($line =~ /(N|I)H:i:(\d+)/){
			$line =~ /(N|I)H:i:(\d+)/;
			$IH_tag = $2;
		    }
		    if ($line =~ /HI:i:(\d+)/){
			$line =~ /HI:i:(\d+)/;
			$HI_tag = $1;
		    }
		    my $for_hash = "$readname:$IH_tag:$HI_tag";
		    if (exists $READ_HASH{$chr}{$for_hash}){
			next;
		    }
		    else{
			print OUT "$line\n";
			$READ_HASH{$chr}{$for_hash} = 1;
		    }
		}
		close(FILE);
	    }
	    close(OUT);
	}
    }
}
if ($NU eq "true"){
    my ($outEx, $outInt, $dir, $outEx_a, $outInt_a, $dir_a);
    if ($stranded eq "false"){
	$outEx = "$LOC/$id/EIJ/NU/$id.filtered_nu_exonmappers.highexp_shuf_norm.sam";
	$outInt = "$LOC/$id/EIJ/NU/$id.filtered_nu_intronmappers.highexp_shuf_norm.sam";
        $dir = "$LOC/$id/EIJ/NU";
    }
    if ($stranded eq "true"){
        $outEx = "$LOC/$id/EIJ/NU/sense/$id.filtered_nu_exonmappers.highexp_shuf_norm.sam";
        $outInt = "$LOC/$id/EIJ/NU/sense/$id.filtered_nu_intronmappers.highexp_shuf_norm.sam";
        $dir = "$LOC/$id/EIJ/NU/sense/";
        $outEx_a = "$LOC/$id/EIJ/NU/antisense/$id.filtered_nu_exonmappers.highexp_shuf_norm.sam";
        $outInt_a = "$LOC/$id/EIJ/NU/antisense/$id.filtered_nu_intronmappers.highexp_shuf_norm.sam";
        $dir_a = "$LOC/$id/EIJ/NU/antisense/";
    }
    my @ex = glob("$dir/*exonmappers*.highexp.sam");
    if (@ex > 0){
	open(OUT, ">$outEx") or die;
	%READ_HASH=();
	foreach my $file (@ex){
	    open(FILE, $file) or die "cannot find $file file\n";
	    while(my $line = <FILE>){
		chomp($line);
		if ($line =~ /^@/){
		    next;
		}
		my @a = split (/\t/, $line);
		my $readname = $a[0];
		$readname =~ s/[^A-Za-z0-9 ]//g;
		my $chr = $a[2];
		my ($HI_tag, $IH_tag);
		if ($line =~ /(N|I)H:i:(\d+)/){
		    $line =~ /(N|I)H:i:(\d+)/;
		    $IH_tag = $2;
		}
		if ($line =~ /HI:i:(\d+)/){
		    $line =~ /HI:i:(\d+)/;
		    $HI_tag = $1;
		}
		my $for_hash = "$readname:$IH_tag:$HI_tag";
		if (exists $READ_HASH{$chr}{$for_hash}){
		    next;
		}
		else{
		    print OUT "$line\n";
		    $READ_HASH{$chr}{$for_hash} = 1;
		}
	    }
	    close(FILE);
	}
	close(OUT);
    }
    my @int = glob("$dir/*intronmappers*.highexp.sam");
    if (@int > 0){
	open(OUT, ">$outInt") or die;
	%READ_HASH=();
	foreach my $file (@int){
	    open(FILE, $file) or die "cannot find $file file\n";
	    while(my $line = <FILE>){
		chomp($line);
		if ($line =~ /^@/){
		    next;
		}
		my @a = split (/\t/, $line);
		my $readname = $a[0];
                    $readname =~ s/[^A-Za-z0-9 ]//g;
		my $chr = $a[2];
		my ($HI_tag, $IH_tag);
		if ($line =~ /(N|I)H:i:(\d+)/){
		    $line =~ /(N|I)H:i:(\d+)/;
		    $IH_tag = $2;
		}
		if ($line =~ /HI:i:(\d+)/){
		    $line =~ /HI:i:(\d+)/;
		    $HI_tag = $1;
		}
		my $for_hash = "$readname:$IH_tag:$HI_tag";
		if (exists $READ_HASH{$chr}{$for_hash}){
		    next;
		}
		else{
		    print OUT "$line\n";
		    $READ_HASH{$chr}{$for_hash} = 1;
		}
	    }
	    close(FILE);
	}
	close(OUT);
    }
    if ($stranded eq "true"){
	my @ex = glob("$dir_a/*exonmappers*.highexp.sam");
	if (@ex > 0){
	    open(OUT, ">$outEx_a") or die;
	    %READ_HASH=();
	    foreach my $file (@ex){
		open(FILE, $file) or die "cannot find $file file\n";
		while(my $line = <FILE>){
		    chomp($line);
		    if ($line =~ /^@/){
			next;
		    }
		    my @a = split (/\t/, $line);
		    my $readname = $a[0];
                $readname =~ s/[^A-Za-z0-9 ]//g;
		    my $chr = $a[2];
		    my ($HI_tag, $IH_tag);
                if ($line =~ /(N|I)H:i:(\d+)/){
                    $line =~ /(N|I)H:i:(\d+)/;
                    $IH_tag = $2;
                }
                if ($line =~ /HI:i:(\d+)/){
                    $line =~ /HI:i:(\d+)/;
                    $HI_tag = $1;
                }
                my $for_hash = "$readname:$IH_tag:$HI_tag";
		    if (exists $READ_HASH{$chr}{$for_hash}){
			next;
		    }
		    else{
			print OUT "$line\n";
			$READ_HASH{$chr}{$for_hash} = 1;
		    }
		}
		close(FILE);
	    }
	    close(OUT);
	}
	my @int = glob("$dir_a/*intronmappers*.highexp.sam");
	if (@int > 0){
	    open(OUT, ">$outInt_a") or die;
	    %READ_HASH=();
	    foreach my $file (@int){
		open(FILE, $file) or die "cannot find $file file\n";
		while(my $line = <FILE>){
		    chomp($line);
		    if ($line =~ /^@/){
			next;
		    }
		    my @a = split (/\t/, $line);
		    my $readname = $a[0];
                    $readname =~ s/[^A-Za-z0-9 ]//g;
		    my $chr = $a[2];
		    my ($HI_tag, $IH_tag);
		    if ($line =~ /(N|I)H:i:(\d+)/){
			$line =~ /(N|I)H:i:(\d+)/;
			$IH_tag = $2;
		    }
		    if ($line =~ /HI:i:(\d+)/){
			$line =~ /HI:i:(\d+)/;
			$HI_tag = $1;
		    }
		    my $for_hash = "$readname:$IH_tag:$HI_tag";
		    if (exists $READ_HASH{$chr}{$for_hash}){
			next;
		    }
		    else{
			print OUT "$line\n";
			$READ_HASH{$chr}{$for_hash} = 1;
		    }
		}
		close(FILE);
	    }
	    close(OUT);
	}
    }
}
print "got here\n";
