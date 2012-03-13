package MouseX::App::Cmd::Command;
use 5.006;
use strict;
use warnings;

# VERSION
use Mouse;
use English '-no_match_vars';
use Getopt::Long::Descriptive ();
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

sub _process_args {    ## no critic (ProhibitUnusedPrivateSubroutines)
    my ( $class, $args ) = @ARG;
    local @ARGV = @{$args};

    my $config_from_file;
    if ( $class->meta->does_role('MouseX::ConfigFromFile') ) {
        local @ARGV = @ARGV;

        my $configfile;
        my $opt_parser;
        {
            ## no critic (Modules::RequireExplicitInclusion)
            $opt_parser
                = Getopt::Long::Parser->new( config => [qw( pass_through)] );
        }
        $opt_parser->getoptions( 'configfile=s' => \$configfile );
        if ( !defined $configfile ) {
            my $cfmeta = $class->meta->find_attribute_by_name('configfile');
            if ( $cfmeta->has_default ) { $configfile = $cfmeta->default }
        }

        if ( defined $configfile ) {
            $config_from_file = $class->get_config_from_file($configfile);
        }
    }

    my %processed = $class->_parse_argv(
        params => { argv => \@ARGV },
        options => [ $class->_attrs_to_options($config_from_file) ],
    );

    my @out
        = ( $processed{params}, $processed{argv}, usage => $processed{usage},
        );

    # params from CLI are also fields in MouseX::Getopt
    if ($config_from_file) { push @out, %{$config_from_file} }
    return @out, %{ $processed{params} };
}

sub _usage_format {    ## no critic (ProhibitUnusedPrivateSubroutines)
    my $class = shift;
    return $class->usage_desc();
}

1;

# ABSTRACT: Base class for commands.

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

This is a replacement base class for L<App::Cmd::Command|App::Cmd::Command>
classes that includes
L<MouseX::Getopt|MouseX::Getopt> and the glue to combine the two.

=method _process_args

Replaces L<App::Cmd::Command|App::Cmd::Command>'s argument processing in in
favor of
L<MouseX::Getopt|MouseX::Getopt> based processing.

=head1 SEE ALSO

=over

=item L<App::Cmd::Command|App::Cmd::Command>

=item L<MouseX::Getopt|MouseX::Getopt>

=back
