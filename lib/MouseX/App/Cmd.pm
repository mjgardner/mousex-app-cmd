package MouseX::App::Cmd;

# ABSTRACT: Mashes up L<MouseX::Getopt|MouseX::Getopt> and L<App::Cmd|App::Cmd>.

use File::Basename ();
use Mouse;

extends qw(Mouse::Object App::Cmd);

sub BUILDARGS {
  my $class = shift;
  return {} unless @_;
  return { arg => $_[0] } if @_ == 1;;
  return { @_ };
}

sub BUILD {
  my ($self,$args) = @_;

  my $class = blessed $self;
  my $arg0 = $0;
  $self->{arg0}      = File::Basename::basename($arg0);
  $self->{command}   = $class->_command( {}  );
  $self->{full_arg0} = $arg0;
  return;
}

1;

__END__

=head1 SYNOPSIS

See L<App::Cmd|App::Cmd/SYNOPSIS>.

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

This module marries L<App::Cmd|App::Cmd> with L<MouseX::Getopt|MouseX::Getopt>.

Use it like L<App::Cmd|App::Cmd> advises (especially see L<App::Cmd::Tutorial|App::Cmd::Tutorial>),
swapping L<App::Cmd::Command|App::Cmd::Command> for L<MouseX::App::Cmd::Command|MouseX::App::Cmd::Command>.

Then you can write your Mouse commands as Mouse classes, with L<MouseX::Getopt|MouseX::Getopt>
defining the options for you instead of C<opt_spec> returning a
L<Getopt::Long::Descriptive|Getopt::Long::Descriptive> spec.
