package MouseX::App::Cmd::Command;

# ABSTRACT: Base class for L<MouseX::Getopt|MouseX::Getopt> based L<App::Cmd::Command|App::Cmd::Command>s.

use English '-no_match_vars';
use Getopt::Long::Descriptive ();
use Mouse;
with 'MouseX::Getopt';
extends qw(Mouse::Object App::Cmd::Command);

has usage => (
    metaclass => 'NoGetopt',
    isa       => 'Object',
    is        => 'ro',
    required  => 1,
);

has app => (
    metaclass => 'NoGetopt',
    isa       => 'MouseX::App::Cmd',
    is        => 'ro',
    required  => 1,
);

sub _process_args {
    my ( $class, $args, @params ) = @ARG;
    local @ARGV = @{$args};

    my $config_from_file;
    if ( $class->meta->does_role('MouseX::ConfigFromFile') ) {
        local @ARGV = @ARGV;

        my $configfile;
        my $opt_parser = Getopt::Long::Parser->new(
            config => [
                qw( pass_through
                    )
            ]
        );
        $opt_parser->getoptions( 'configfile=s' => \$configfile );
        if ( !defined $configfile ) {
            my $cfmeta = $class->meta->find_attribute_by_name('configfile');
            $configfile = $cfmeta->default if $cfmeta->has_default;
        }

        if ( defined $configfile ) {
            $config_from_file = $class->get_config_from_file($configfile);
        }
    }

    my %processed = $class->_parse_argv(
        params => { argv => \@ARGV },
        options => [ $class->_attrs_to_options($config_from_file) ],
    );

    return (
        $processed{params},
        $processed{argv},
        usage => $processed{usage},

        # params from CLI are also fields in MouseX::Getopt
        %{  $config_from_file
            ? { %{$config_from_file}, %{ $processed{params} } }
            : $processed{params}
            },
    );
}

sub _usage_format {
    my $class = shift;
    return $class->usage_desc();
}

1;

__END__

=head1 SYNOPSIS

    use Mouse;

    extends qw(MouseX::App::Cmd::Command);

    # no need to set opt_spec
    # see MouseX::Getopt for documentation on how to specify options
    has option_field => (
        isa => "Str",
        is  => "rw",
        required => 1,
    );

    sub execute {
        my ( $self, $opts, $args ) = @_;

        print $self->option_field; # also available in $opts->{option_field}
    }

=head1 DESCRIPTION

This is a replacement base class for L<App::Cmd::Command|App::Cmd::Command> classes that includes
L<MouseX::Getopt|MouseX::Getopt> and the glue to combine the two.

=head1 METHODS

=over 4

=item _process_args

Replaces L<App::Cmd::Command|App::Cmd::Command>'s argument processing in in favor of
L<MouseX::Getopt|MouseX::Getopt> based processing.

=back

=head1 TODO

Full support for L<Getopt::Long::Descriptive|Getopt::Long::Descriptive>'s abilities is not yet written.

This entails taking apart the attributes and getting at the descriptions.

This might actually be added upstream to L<MouseX::Getopt|MouseX::Getopt>, so until we decide
here's a functional but not very helpful (to the user) version anyway.
