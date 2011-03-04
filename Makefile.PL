#!/usr/bin/perl -w

use strict;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'MouseX::App::Cmd',
    VERSION_FROM => 'lib/MouseX/App/Cmd.pm',
    INSTALLDIRS  => 'site',
    SIGN         => 1,
    PL_FILES     => {},
    PREREQ_PM    => {
        'Test::use::ok'             => 0,
        'App::Cmd'                  => 0.3,
        'Mouse'                     => 0.86,
        'MouseX::Getopt'            => "0.18",
        'Getopt::Long::Descriptive' => 0,
    },
);

