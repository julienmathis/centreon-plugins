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

package cloud::aws::ec2::mode::cpu;

use strict;
use warnings;
use Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(&cloudwatchCheck);

my @Param;

$Param[0] = {
    'NameSpace'  => 'AWS/EC2',
    'MetricName' => 'CPUUtilization',
    'ObjectName' => 'InstanceId',
    'Unit'       => 'Percent',
    'Labels'     => {
        'ShortOutput' => "CPU Usage is %.2f%%",
        'LongOutput'  => "CPU Usage is %.2f%%",
        'PerfData'    => 'cpu',
        'Unit'        => '%',
        'Value'       => "%.2f",
    }
};

sub run
{
    my ($self, %options) = @_;

    my ($msg, $exit_code, $awsapi);

    if ( defined( $CloudwatchMetrics->{ $self->{option_results}->{metric} } ) ) {
	centreon::plugins::misc::mymodule_load(output => $options{output}, module => $CloudwatchMetrics->{$self->{option_results}->{metric}},
                                               error_msg => "Cannot load module '" . $CloudwatchMetrics->{$self->{option_results}->{metric}} . "'.");
        my $func = $CloudwatchMetrics->{$self->{option_results}->{metric}}->can('cloudwatchCheck');
        $func->($self);
    } else {
        $self->{output}->add_option_msg( short_msg => "Wrong option. Cannot find metric '" . $self->{option_results}->{metric} . "'." );
        $self->{output}->option_exit();
    }

    foreach my $metric (@{$self->{metric}})
    {
        $self->manage_selection($metric);
        $awsapi = $options{custom};
        $self->{command_return} = $awsapi->execReq($apiRequest);
        $self->{output}->perfdata_add(
            label => sprintf($metric->{Labels}->{PerfData}, unit => $metric->{Labels}->{Unit}),
            value => sprintf($metric->{Labels}->{Value}, $self->{command_return}->{Datapoints}[0]->{Average}),
            warning  => $self->{perfdata}->get_perfdata_for_output(label => 'warning'),
            critical => $self->{perfdata}->get_perfdata_for_output(label => 'critical'),

            #min => 0,
            #max => 100
	    );
        $exit_code = $self->{perfdata}->threshold_check(
            value     => $self->{command_return}->{Datapoints}[0]->{Average},
            threshold => [{label => 'critical', 'exit_litteral' => 'critical'}, {label => 'warning', exit_litteral => 'warning'}]
	    );

        $self->{output}->output_add(long_msg => sprintf($metric->{Labels}->{LongOutput}, $self->{command_return}->{Datapoints}[0]->{Average}));

        $self->{output}->output_add(
            severity  => $exit_code,
            short_msg => sprintf($metric->{Labels}->{ShortOutput}, $self->{command_return}->{Datapoints}[0]->{Average})
	    );
    }

    $self->{output}->display();
    $self->{output}->exit();
}


sub cloudwatchCheck {
    my ($self) = @_;

    @{ $self->{metric} } = @Param;
}

1;
