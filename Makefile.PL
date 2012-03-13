
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Mashes up L<MouseX::Getopt|MouseX::Getopt> and L<App::Cmd|App::Cmd>.",
  "AUTHOR" => "Yuval Kogman <nothingmuch\@woobling.org>, Guillermo Roditi <groditi\@cpan.org>, Mark Gardner <mjgardner\@cpan.org>",
  "BUILD_REQUIRES" => {
    "Carp" => 0,
    "Data::Dumper" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "MouseX::ConfigFromFile" => 0,
    "Scalar::Util" => 0,
    "Test::More" => "0.94",
    "Test::Output" => 0,
    "Test::Requires" => 0,
    "YAML" => 0,
    "base" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "MouseX-App-Cmd",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "MouseX::App::Cmd",
  "PREREQ_PM" => {
    "App::Cmd" => "0.3",
    "App::Cmd::Command" => 0,
    "English" => 0,
    "File::Basename" => 0,
    "Getopt::Long::Descriptive" => "0.091",
    "Mouse" => "0.86",
    "Mouse::Object" => 0,
    "MouseX::Getopt" => "0.18",
    "Test::use::ok" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.11",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



