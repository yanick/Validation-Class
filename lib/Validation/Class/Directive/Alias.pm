# ABSTRACT: Alias Directive for Validation Class Field Definitions

package Validation::Class::Directive::Alias;

use strict;
use warnings;

use base 'Validation::Class::Directive';

use Validation::Class::Util;

# VERSION

=head1 SYNOPSIS

    use Validation::Class::Simple;

    my $rules = Validation::Class::Simple->new(
        fields => {
            login  => {
                alias => 'username'
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

Validation::Class::Directive::Alias is a core validation class field directive
that provides the ability to map arbitrary parameter names with a field's
parameter value.

=over 8

=item * alternative argument: an-array-of-aliases

This directive can be passed a single value or an array of values:

    fields => {
        login  => {
            alias => ['username', 'email_address']
        }
    }

=back

=cut

has 'mixin'        => 0;
has 'field'        => 1;
has 'multi'        => 0;
has 'dependencies' => sub {{
    normalization => ['name'],
    validation    => ['name']
}};

sub normalize {

    my ($self, $proto, $field, $param) = @_;

    # create a map from aliases if applicable

    $self->execute_alias_mapping($proto, $field, $param);

    return $self;

}

sub before_validation {

    my ($self, $proto, $field, $param) = @_;

    # create a map from aliases if applicable

    $self->execute_alias_mapping($proto, $field, $param);

    return $self;

}

sub execute_alias_mapping {

    my ($self, $proto, $field, $param) = @_;

    if (defined $field->{alias}) {

        my $name = $field->{name};

        my $aliases = isa_arrayref($field->{alias}) ?
            $field->{alias} : [$field->{alias}]
        ;

        foreach my $alias (@{$aliases}) {

            if ($proto->params->has($alias)) {

                # rename the submitted parameter alias with the field name
                $proto->params->add($name => $proto->params->delete($alias));

                push @{$proto->stash->{'validation.fields'}}, $name unless
                    grep { $name eq $_} @{$proto->stash->{'validation.fields'}}
                ;

            }

        }

    }

    return $self;

}

1;
