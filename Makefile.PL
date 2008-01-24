use strict;
use inc::Module::Install;

name 'Taint-Util';

author 'Ævar Arnfjörð Bjarmason <avar@cpan.org>';

abstract_from 'Util.pm';
license_from  'Util.pm';
version_from  'Util.pm';

# Util.pm
requires 'Exporter';
requires 'XSLoader';

# t/
build_requires 'Test::More' => 0; # 5.007003

tests 't/*.t';

auto_install;
WriteAll;
