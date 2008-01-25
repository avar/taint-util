package Taint::Util;
use XSLoader ();

$VERSION   = '0.06';

@EXPORT_OK{qw(tainted taint untaint)} = ();

sub import
{
    shift;
    my $caller = caller;
    for (@_ ? @_ : keys %EXPORT_OK)
    {
        die qq["$_" is not exported by the @{[__PACKAGE__]} module"]
            unless exists $EXPORT_OK{$_};
        *{"$caller\::$_"} = \&$_;
    }
}

XSLoader::load __PACKAGE__, $VERSION;

1;

__END__

=head1 NAME

Taint::Util - Test for and flip the taint flag without regex matches or C<eval>

=head1 SYNOPSIS

    #!/usr/bin/env perl -T
    use Taint::Util;

    # eek!
    untaint $ENV{PATH};

    # $sv now tainted under taint mode (-T)
    taint(my $sv = "hlagh");

    # Untaint $sv again
    untaint $sv if tainted $sv;

=head1 DESCRIPTION

Wraps perl's internal routines for checking and setting the taint flag
and thus does not rely on regular expressions for untainting or odd
tricks involving C<eval> and C<kill> for checking whether data is
tainted, instead it checks and flips a flag on the scalar in-place.

=head1 FUNCTIONS

=head2 tainted

Returns a boolean indicating whether a scalar is tainted. Always false
when not under taint mode.

=head2 taint & untaint

Taints or untaints given values, arrays will be flattened and their
elements tainted, likewise with the values of hashes (keys can't be
tainted, see L<perlsec>). Returns no value (which evaluates to false).

    untaint(%ENV);                  # Untaints the environment
    taint(my @hlagh = qw(a o e u)); # elements of @hlagh now tainted

References (being scalars) can also be tainted, a stringified
reference reference raises an error where a tainted scalar would:

    taint(my $ar = \@hlagh);
    system echo => $ar;      # err: Insecure dependency in system

This feature is used by perl internally to taint the blessed object
C<< qr// >> stringifies to.

    taint(my $str = "oh noes");
    my $re = qr/$str/;
    system echo => $re;      # err: Insecure dependency in system

This does not mean that tainted blessed objects with overloaded
stringification via L<overload> need return a tainted object since
those objects may return a non-tainted scalar when stringified (see
F<t/reftaint.t> for an example). The internal handling of C<< qr// >>
however ensures that this holds true.

File handles can also be tainted, but this probably useless as the
handle itself and not lines retrieved from it will be tainted.

    taint(*DATA);    # *DATA tainted
    my $ln = <DATA>; # $ln not tainted

=head1 EXPORTS

Exports C<tainted>, C<taint> and C<untaint> by default. Individual
functions can be exported by specifying them in the C<use> list, to
export none use C<()>.

=head1 HISTORY

I wrote this when implementing L<re::engine::Plugin> so that someone
writing a custom regex engine with it wouldn't have to rely on perl
regexps for untainting capture variables, which would be a bit odd.

=head1 SEE ALSO

L<perlsec>

=head1 AUTHOR

E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason <avar@cpan.org>

=head1 LICENSE

Copyright 2007-2008 E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
