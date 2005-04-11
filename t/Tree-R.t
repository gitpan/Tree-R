# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Tree-R.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 7;
BEGIN { use_ok('Tree::R') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my %objects = (
	       1 => [2,4,4,7],
	       2 => [3,2,7,6],
	       3 => [6,3,9,5],
	       4 => [6,8,9,10],
	       5 => [10,7,13,9]
	       );

my $rtree = new Tree::R m=>2,M=>3;

for my $object (keys %objects) {
    my @bbox = @{$objects{$object}}; # (minx,miny,maxx,maxy)
    $rtree->insert($object,@bbox);
}

for (1..2) {
    my @point = (6.5,4); # (x,y)
    my @results;
    $rtree->query_point(@point,\@results);
    
    my @test = sort @results;
    ok("@test" eq "2 3", "query_point $_");
    
    my @rect = (5,0,11,11); # (minx,miny,maxx,maxy)
    @results = ();
    $rtree->query_completely_within_rect(@rect,\@results);
    
    @test = sort @results;
    ok("@test" eq "3 4", "query_completely_within_rect $_");
    
    @results = ();
    $rtree->query_partly_within_rect(@rect,\@results);
    
    @test = sort @results;
    ok("@test" eq "2 3 4 5", "query_partly_within_rect $_");
    
    $rtree->remove(3);
    $rtree->insert(3,@{$objects{3}});   
}
