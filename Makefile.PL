use ExtUtils::MakeMaker;

WriteMakefile(
    NAME		  => 'Taint::Util',
    AUTHOR        => 'Ævar Arnfjörð Bjarmason <avar@cpan.org>',
    ABSTRACT_FROM => 'Util.pm',
    VERSION_FROM  => 'Util.pm',
    LICENSE       => 'perl',
    PREREQ_PM     => {
        # Util.pm
        'XSLoader'   => 0,

        # t/
        'Test::More' => 0,
    },
);
