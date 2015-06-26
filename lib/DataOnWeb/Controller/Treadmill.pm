package DataOnWeb::Controller::Treadmill;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub show {
    my $self = shift;

}

sub all_tm {
    my $self = shift;
    my $db = $self->app->db;

    my $users = $self->get_all_users_by_id();
    my $sth = $db->prepare("SELECT * FROM treadmill");
    $sth->execute;
    my $treadmill_entries = { total => 0, rows => [] };
    while(my @treadmill_entry = $sth->fetchrow_array) {
        $treadmill_entries->{total}++;
        push(@{$treadmill_entries->{rows}}, { id => $treadmill_entry[0],
            date => $treadmill_entry[1],
            energy => $treadmill_entry[2],
            distance => $treadmill_entry[3],
            user_name => $users->{$treadmill_entry[4]},
        });
    }
    $sth->finish;

    $self->render(json => $treadmill_entries);
}

sub get_all_users_by_id {
    my $self = shift;
    my $db = $self->app->db;

    my $users = {};
    my $sth = $db->prepare('SELECT user_id, user_name FROM datauser');
    $sth->execute;
    while(my @user = $sth->fetchrow_array) {
        $users->{$user[0]} = $user[1];
    }
    $sth->finish;

    return $users;
}

sub get_users {
    my $self = shift;
    my $db = $self->app->db;

    my $users = [];
    my $sth = $db->prepare('SELECT user_id, user_name FROM datauser');
    $sth->execute;
    while(my @user = $sth->fetchrow_array) {
        push($users, {user => $user[0], user_name => $user[1]});
    }
    $sth->finish;

    $self->render(json => $users);
}

sub add_tm {
    my $self = shift;
    my $db = $self->app->db;

    my $id = $self->param('id');
    my $date = $self->param('date');
    my $energy = $self->param('energy');
    my $distance = $self->param('distance');
    my $user_id = $self->param('user');

    say "id ", $id;
    say "date ", $date;
    say "energy ", $energy;
    say "distance ", $distance;
    say "user id ", $user_id;
    
    if(-1 != $id) {
        $db->do('UPDATE datatreadmill SET treadmill_date = ?, treadmill_energy = ?, treadmill_distance = ?, treadmill_user_id = ?', undef, $date, $energy, $distance, $user_id);
    }
    else {
        $db->do('INSERT INTO treadmill(treadmill_date, treadmill_energy, treadmill_distance, treadmill_user_id) VALUES(?,?,?,?)', undef, $date, $energy, $distance, $user_id);
    }

    $self->render(json => "OK");
}

sub show_bicycle {
    my $self = shift;
    my $db = $self->app->db;
}

1;
