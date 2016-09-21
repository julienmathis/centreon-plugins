#
# Copyright 2016 Centreon (http://www.centreon.com/)
#
# Centreon is a full-fledged industry-strength solution that meets
# the needs in IT infrastructure and application monitoring for
# service performance.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package cloud::aws::ec2::mode::instancestate;

use base qw(centreon::plugins::mode);

# Needed libraries
use strict;
use warnings;

# Custom library
use JSON;
use Data::Dumper;

use centreon::plugins::misc;

my %EC2_instance_states = (
    'pending'       => 'WARNING',
    'running'       => 'OK',
    'shutting-down' => 'CRITICAL',
    'terminated'    => 'CRITICAL',
    'stopping'      => 'CRITICAL',
    'stopped'       => 'CRITICAL'
);

my $apiRequest = {
    'command'    => 'ec2',
    'subcommand' => 'describe-instance-status',
};

sub new {
    my ( $class, %options ) = @_;
    my $self = $class->SUPER::new( package => __PACKAGE__, %options );
    bless $self, $class;

    $self->{version} = '0.1';

    #$self->{result} = {};
    return $self;
}


#    $options{options}->add_options(arguments => {
#            "state:s"                => { name => 'state', default => 'all' },
#            "no-includeallinstances" => { name => 'includeallinstances' },
#            "exclude:s"              => { name => 'exclude' },
#            "instanceid:s"           => { name => 'instanceid' }
#        }
#    );


sub check_options {
    my ($self, %options) = @_;
    $self->SUPER::init(%options);
}

sub run {
    my ( $self, %options ) = @_;

    my ($msg, $exit_code, $awsapi);
    my $old_status = 'OK';

    


    print "OK";
    exit();
}

1;

__END__

=head1 MODE

Get the state of your EC2 instances (running, stopped, ...)

=over 8

=item B<--state>

(optional) Specific state to query.

=item B<--no-includeallinstances>

(optional) Includes the health status for running instances only.

=item B<--exclude>

(optional) State to exclude from the query.

=back

=cut
