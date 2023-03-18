#!/usr/bin/perl
# Script to automatically get drops from Twitch streams
# Created 3/17/2023
use strict;
use warnings;
use LWP::UserAgent;

my $BANNER = <<EOL;

           ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
          ▓▓▓▓▓""""""""""""""""""""]▓▓▓
         @▓▓▓▓▓                    ▐▓▓▓
         ▓▓▓▓▓▓     ____  .___,    ▐▓▓▓
         ▓▓▓▓▓▓     ▓▓▓▓  ]▓▓▓▌    ▐▓▓▓
         ▓▓▓▓▓▓     ▓▓▓▓  ]▓▓▓▌    ▐▓▓▓
         ▓▓▓▓▓▓     ▓▓▓▓  ]▓▓▓▌    ▐▓▓▓
         ▓▓▓▓▓▓     """"  '"""'    ▐▓▓▓
         ▓▓▓▓▓▓                   ▄▓▓▓▓
         ▓▓▓▓▓▓_____    ________á▓▓▓▓
         ▓▓▓▓▓▓▓▓▓▓▓  ╓▓▓▓▓▓▓▓▓▓▓▓▀
         ▓▓▓▓▓▓▓▓▓▓▓▄▓▓▓▓▓▓▓▓▓▓▓▀
         """""""]▓▓▓▓▓▓▓▀""""""
                ]▓▓▓▓▓"
                
██████╗ ██████╗  ██████╗ ██████╗ ███████╗ █████╗ ██████╗ ███╗   ███╗███████╗██████╗ 
██╔══██╗██╔══██╗██╔═══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██╔══██╗
██║  ██║██████╔╝██║   ██║██████╔╝█████╗  ███████║██████╔╝██╔████╔██║█████╗  ██████╔╝
██║  ██║██╔══██╗██║   ██║██╔═══╝ ██╔══╝  ██╔══██║██╔══██╗██║╚██╔╝██║██╔══╝  ██╔══██╗
██████╔╝██║  ██║╚██████╔╝██║     ██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗██║  ██║
╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝

EOL

print($BANNER);

# Channels to check for drops
my @channel_urls = (
    "https://www.twitch.tv/tarik",
    "https://www.twitch.tv/valorant",
    "https://www.twitch.tv/rocketleague",
    "https://www.twitch.tv/rocketleaguesam",
    "https://www.twitch.tv/rocketleaguemena",
    "https://www.twitch.tv/rocketleagueapac",
    "https://www.twitch.tv/playapex"
);

my $user_agent = LWP::UserAgent->new;
$user_agent->agent("Mozilla/5.0");
$user_agent->protocols_allowed(["https",]);
$user_agent->timeout(5);

print("Set up LWP User Agent...\n");

while (1)
{
    foreach my $channel (@channel_urls)
    {
        print("Fetching " . $channel . "...");

        # Check if current channel is live and has drops enabled
        my $response = $user_agent->get($channel);

        if ($response->is_success)
        {
            print("Success\n");
            print($response->status_line . "\n");
           
            open(my $fh, ">", "twitch.html") or die "Can't open file";
            print $fh $response->decoded_content;
            close($fh);
            exit;

            if ($response->decoded_content =~ m/"isLiveBroadcast":true/ and
                $response->decoded_content =~ m/<span>DropsEnabled<\/span>/)
            {
                # TODO: figure out difference between channel with drops on and channel with drops off
                # Since LWP is only fetching HTML
                
                # Channel is live and has drops enabled
                # Launch browser to collect drops
                print("Channel " . $channel . " is live and has drops on!\n");
            }
        }
    }

    # Run loop every 10 mins
    sleep(600);
}
