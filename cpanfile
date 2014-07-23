## util
requires "Text::CSV";
requires "HTTP::Session";

## database
requires "Teng";
requires "Teng::Plugin::SearchJoined";

## web framework
requires "Amon2";
requires "Amon2::Lite";
requires "Amon2::Auth";
requires "Amon2::Plugin::Web::HTTPSession";
requires "Teng";
requires "Teng::Schema::Loader";

## plack
requires "Plack";
requires "Starlet";

## plack auth
requires 'Exporter::Lite';
requires 'git://github.com/rymizuki/p5-Amon2-Web-Auth-Path';
