# ABSTRACT: MinAlpha Directive for Validation Class Field Definitions

package Validation::Class::Directive::MinAlpha;

use strict;
use warnings;

use base 'Validation::Class::Directive';

use Validation::Class::Util;

# VERSION

=head1 SYNOPSIS

    use Validation::Class::Simple;

    my $rules = Validation::Class::Simple->new(
        fields => {
            password => {
                min_alpha => 1
            }
        }
    );

    # set parameters to be validated
    $rules->params->add($parameters);

    # validate
    unless ($rules->validate) {
        # handle the failures
    }

=head1 DESCRIPTION

Validation::Class::Directive::MinAlpha is a core validation class field
directive that validates the length of alphabetic characters in the associated
parameters.

=cut

has 'mixin'     => 1;
has 'field'     => 1;
has 'multi'     => 0;
has 'message'   => '%s must not contain less than %s alphabetic characters';

sub validate {

    my $self = shift;

    my ($proto, $field, $param) = @_;

    if (defined $field->{min_alpha} && defined $param) {

        my $min_alpha = $field->{min_alpha};

        if ( $field->{required} || $param ) {

            my @i = ($param =~ /[a-zA-Z]/g);

            if (@i < $min_alpha) {

                $self->error(@_, $min_alpha);

            }

        }

    }

    return $self;

}

1;
