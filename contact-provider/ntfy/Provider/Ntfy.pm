# Copyright (c) 2026 Rubix Studios
# SPDX-License-Identifier: MIT 
# 
# ntfy iContact provider for WHM/cPanel.

package Cpanel::iContact::Provider::Ntfy;

use strict;
use warnings;

use parent 'Cpanel::iContact::Provider';

use Try::Tiny;

use Cpanel::Exception ();
use Cpanel::Config::LoadWwwAcctConf ();
use HTTP::Tiny;
use utf8 ();

sub send {
    my ($self) = @_;

    my $args_hr = $self->{'args'};
    my @errs;

    my $subject_copy = $args_hr->{'subject'};

    my $body_copy = ref $args_hr->{'text_body'}
        ? ${ $args_hr->{'text_body'} }
        : $args_hr->{'text_body'};

    my $subject = $subject_copy;
    my $body    = $body_copy;

    my $wwwacct_ref =
      Cpanel::Config::LoadWwwAcctConf::loadwwwacctconf();

    my $server =
      $wwwacct_ref->{'NTFYHOST'} // q{};

    my $token =
      $wwwacct_ref->{'NTFYAUTHTOKEN'} // q{};

    if ( !$server ) {
        die Cpanel::Exception::create(
            'MissingParameter',
            'The system could not send the ntfy notification because no ntfy host is configured.'
        );
    }

    my $importance =
         $args_hr->{'importance'}
      // $args_hr->{'level'}
      // 3;

    if ( $importance == 0 ) {
        return 1;
    }

    my $priority = 3;
    my $tags     = 'information';

    if ( $importance == 1 ) {
        $priority = 5;
        $tags     = 'rotating_light,warning';

    }
    elsif ( $importance == 2 ) {
        $priority = 4;
        $tags     = 'warning';

    }
    elsif ( $importance == 3 ) {
        $priority = 3;
        $tags     = 'information';
    }

    foreach my $topic ( @{ $args_hr->{'to'} } ) {
        my $safe_subject = $subject;

        utf8::decode($safe_subject);

        $safe_subject =~
          tr/\x{2018}\x{2019}\x{201C}\x{201D}/''""/;

        $safe_subject =~
          s/[^\x20-\x7E]//g;

        my $http = HTTP::Tiny->new(
            verify_SSL => 1,
            timeout    => 15,
        );

        try {
            my %headers = (
                'Title'        => $safe_subject,
                'Priority'     => $priority,
                'Tags'         => $tags,
                'Content-Type' => 'text/plain',
            );

            if ($token) {
                $headers{'Authorization'} =
                  "Bearer ${token}";
            }

            my $response = $http->post(
                "${server}/${topic}",
                {
                    headers => \%headers,
                    content => $body,
                }
            );

            if ( !$response->{success} ) {
                die Cpanel::Exception::create(
                    'ConnectionFailed',
                    'The system could not send data to ntfy due to an error: [_1]',
                    [
                        $response->{content}
                          || $response->{reason}
                    ]
                );
            }

        }
        catch {
            push @errs, $_;
        };
    }

    if (@errs) {
        die Cpanel::Exception::create(
            'Collection',
            [ exceptions => \@errs ]
        );
    }

    return 1;
}

1;