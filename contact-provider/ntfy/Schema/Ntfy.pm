# Copyright (c) 2026 Rubix Studios
# SPDX-License-Identifier: MIT 
# 
# ntfy iContact provider for WHM/cPanel.

package Cpanel::iContact::Provider::Schema::Ntfy;

use strict;
use warnings;

use Cpanel::LoadModule ();

sub get_settings {
    return {
        'NTFYHOST' => {
            'shadow'   => 1,
            'type'     => 'text',
            'checkval' => sub {
                Cpanel::LoadModule::load_perl_module(
                    'Cpanel::StringFunc::Trim'
                );

                my $value = shift();

                $value =
                  Cpanel::StringFunc::Trim::ws_trim($value);

                return q{}
                  unless $value =~ m{^https?://.+$};

                return $value;
            },
            'label' =>
              'ntfy Server URL',
            'help' =>
              'Example: https://ntfy.example.com',
        },
        'NTFYAUTHTOKEN' => {
            'shadow'   => 1,
            'type'     => 'password',
            'checkval' => sub {
                Cpanel::LoadModule::load_perl_module(
                    'Cpanel::StringFunc::Trim'
                );

                my $value = shift();

                $value =
                  Cpanel::StringFunc::Trim::ws_trim($value);

                return $value;
            },
            'label' =>
              'ntfy Authentication Token',
            'help' =>
              'Bearer token for ntfy authentication.',
        },
        'CONTACTNTFY' => {
            'name'     => 'Ntfy',
            'shadow'   => 1,
            'type'     => 'text',
            'checkval' => sub {

                Cpanel::LoadModule::load_perl_module(
                    'Cpanel::StringFunc::Trim'
                );

                my $value = shift();

                $value =
                  Cpanel::StringFunc::Trim::ws_trim($value);

                return $value if $value eq q{};

                my @topics =
                  split m{\s*,\s*}, $value;

                return join(
                    ',',
                    grep(
                        m{^[a-zA-Z0-9._-]+$},
                        @topics
                    )
                );
            },
            'label' =>
              'ntfy Topics',
            'help' =>
              'Comma-separated ntfy topics. Example: whm,alerts,security',
        },
    };
}

sub get_config {
    return {
        'default_level'    => 'All',
        'display_name'     => 'ntfy',
        'icon_name'        => 'ntfy',
        'icon'             => 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAAPoAAAD6AG1e1JrAAACZUlEQVR4nI2TX0hTURzHrwbRYy89BY16LRAqwmJoOhBSqR6k10bvSdBLGWHJJFs6U7flP9ofN4aTNtf+iBDFlFnM2uY2s6kguJblrkvTebfdc/aNq1aubuUXvk/ndz7nnC/nyzAMwzQ2NhYDKGb2KGEWQJHYWtEeXahNQALAAsAPYALA679YWPODUmNscfHw7is9Xcnz6J30El3AB1PEj4GIH6boJMzv38L8IQBLLAjLbAjmuRDhAGQ2NjW7AS7z1BscuV+fO9vVRI+23KQlHXfpKW0TPd2toGf6H9BSnZJKje20RNeSe7G0AGSJm2GY7dwAOIdmAijTKAibXkf/5BiqdCpU6lpRberEBYsatdYnuPysFzKrmvhWEkAm6/yZBwDn8GwYJ9oaiNLrQXw1hYVUEtccBsgG2lEzqEXtUDcu2ftRMaQhvlQCyGZdBQDHXATHVXdIla4NI7EwBDW8dKBU/wgySxdkg2pU23ohs3UT39dPAPcbwD4bxjltM1nLcJhPLePGqBVV5k5cH7Xilvc5GsZcqH9lh8zeQyZWl/4AuIbnoyjve0gUXjcqje0oN6hQY9Ui9OUjcpSC5vMYTyyg0iEAPguAwgxs8xEcU93Onexp5qX6Vr7C9Jg/b+7gL9r6+Dqnnr/iNvJ1IwN8mb0n40uJPMHPJqB+N06m1pIIri0j+C2J0DqLwHpy2xssQpspRDOrRMgnEY8rtzZHo9H9lNLprdR4Oo0NzoI0p0eaM4hYn09zpqV4/J5cLj/04/QDLMte9Xg8UolEclD0r4tLfE5o2U7b/udfAAD7duos3rZ/6DtisCKyMNBu0wAAAABJRU5ErkJggg==',
    };
}

1;