package DataOnWeb::Controller::Data;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub show {
    my $self = shift;

    $self->stash(msg => 'At the moment two data forms are available. Treadmill and Bicycle.');
}

sub show_treadmill {
    my $self = shift;
    my $db = $self->app->db;

    # Render template "example/welcome.html.ep" with message
    my $treadmill_entries = [];
    my $sth = $db->prepare("SELECT * FROM treadmill");
    $sth->execute;
    while(my $treadmill_entry = $sth->fetchrow_array) {
        push(@$treadmill_entries, { treadmill_id => $treadmill_entry->[0],
            treadmill_date => $treadmill_entry->[1],
            treadmill_energy => $treadmill_entry->[2],
            treadmill_distance => $treadmill_entry->[3],
            treadmill_user_id => $treadmill_entry->[4],
        });
    }
    $sth->finish;

    $self->render(treadmill_entries => $treadmill_entries);
}

sub show_bicycle {
    my $self = shift;
    my $db = $self->app->db;
}

1;
