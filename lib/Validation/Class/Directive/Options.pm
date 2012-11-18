# ABSTRACT: Options Directive for Validation Class Field Definitions

package Validation::Class::Directive::Options;

use base 'Validation::Class::Directive';

use Validation::Class::Core;

# VERSION

=head1 SYNOPSIS

    use Validation::Class::Directive::Options;

    my $directive = Validation::Class::Directive::Options->new;

=head1 DESCRIPTION

Validation::Class::Directive::Options is a core validation class field directive
that provides the ability to do some really cool stuff only we haven't
documented it just yet.

=cut

has 'mixin'     => 1;
has 'field'     => 1;
has 'multi'     => 0;
has 'message'   => '%s must be either %s';

sub _build_validator {

    my ( $directive, $value, $field, $class ) = @_;

    if (defined $value) {

        # build the regex
        my (@options) = "ARRAY" eq ref $directive ?
            @{$directive} : split /(?:\s{1,})?[,\-]{1,}(?:\s{1,})?/, $directive;

        unless ( grep { $value =~ /^$_$/ } @options ) {

            my $handle  = $field->{label} || $field->{name};

            my $error = "$handle must be " .
                join(", ", (@options[(0..($#options-1))])) . " or $options[-1]";

            $field->errors->add($field->{error} || $error);

            return 0;

        }

    }

    return 1;

}

sub validate {

    my $self = shift;

    my ($proto, $field, $param) = @_;

    if (defined $field->{options} && defined $param) {

        my $options = $field->{options};

        if ( $field->{required} || $param ) {

            my (@options) = isa_arrayref($options) ?
                @{$options} : split /(?:\s{1,})?[,\-]{1,}(?:\s{1,})?/, $options
            ;

            unless (grep { $param =~ /^$_$/ } @options) {

                if (my @o = @options) {

                    my$list=(join(' or ',join(', ',@o[0..$#o-1])||(),$o[-1]));

                    $self->error(@_, $list);

                }

            }

        }

    }

    return $self;

}

1;
