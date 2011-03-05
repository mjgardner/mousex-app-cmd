package MouseX::App::Cmd;

# ABSTRACT: Mashes up L<MouseX::Getopt|MouseX::Getopt> and L<App::Cmd|App::Cmd>.

use English '-no_match_vars';
use File::Basename ();
use Mouse;
extends qw(Mouse::Object App::Cmd);

sub BUILDARGS {
    shift;
    return {} if !@ARG;
    return { arg => $ARG[0] } if @ARG == 1;
    return {@ARG};
}

sub BUILD {
    my $self  = shift;
    my $class = blessed $self;

    $self->{arg0}      = File::Basename::basename($PROGRAM_NAME);
    $self->{command}   = $class->_command( {} );
    $self->{full_arg0} = $PROGRAM_NAME;

    return;
}

1;

=head1 SYNOPSIS

    package YourApp::Cmd;
	use Mouse;

    extends qw(MouseX::App::Cmd);


    package YourApp::Cmd::Command::blort;
    use Mouse;

    extends qw(MouseX::App::Cmd::Command);

    has blortex => (
        traits => [qw(Getopt)],
        isa => "Bool",
        is  => "rw",
        cmd_aliases   => "X",
        documentation => "use the blortext algorithm",
    );

    has recheck => (
        traits => [qw(Getopt)],
        isa => "Bool",
        is  => "rw",
        cmd_aliases => "r",
        documentation => "recheck all results",
    );

    sub execute {
        my ( $self, $opt, $args ) = @_;

        # you may ignore $opt, it's in the attributes anyway

        my $result = $self->blortex ? blortex() : blort();

        recheck($result) if $self->recheck;

        print $result;
    }

=head1 DESCRIPTION

This module marries L<App::Cmd|App::Cmd> with
L<MouseX::Getopt|MouseX::Getopt>.
It is a direct port of L<MooseX::App::Cmd|MooseX::App::Cmd> to L<Mouse|Mouse>.

Use it like L<App::Cmd|App::Cmd> advises (especially see
L<App::Cmd::Tutorial|App::Cmd::Tutorial>),
swapping L<App::Cmd::Command|App::Cmd::Command> for
L<MouseX::App::Cmd::Command|MouseX::App::Cmd::Command>.

Then you can write your Mouse commands as Mouse classes, with
L<MouseX::Getopt|MouseX::Getopt>
defining the options for you instead of C<opt_spec> returning a
L<Getopt::Long::Descriptive|Getopt::Long::Descriptive> spec.

=head1 SEE ALSO

=over

=item L<App::Cmd|App::Cmd>

=item L<MouseX::Getopt|MouseX::Getopt>

=item L<MooseX::App::Cmd|MooseX::App::Cmd>

=back
