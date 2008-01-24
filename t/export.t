use strict;

use Test::More tests => 3;

use Taint::Util qw(taint);

ok(defined &taint, 'taint exported');
ok(!(defined &untaint), 'untaint unexported');
ok(!(defined &tainted), 'tainted unexported');
