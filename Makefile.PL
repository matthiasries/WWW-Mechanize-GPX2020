use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'WWW::Mechanize::GPX2020',
    AUTHOR              => 'Matthias Ries <riesm@mad4milk.de>',
    VERSION_FROM        => 'lib/WWW/Mechanize/GPX2020.pm',
    ABSTRACT_FROM       => 'lib/WWW/Mechanize/GPX2020.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'lgpl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'WWW-Mechanize-GPX2020-*' },
);
