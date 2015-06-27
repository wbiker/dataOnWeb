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
    my $sth = $db->prepare("SELECT treadmill_id,treadmill_date,treadmill_duration,treadmill_energy,treadmill_distance,treadmill_user_id FROM treadmill");
    $sth->execute;
    my $treadmill_entries = { total => 0, rows => [] };
    while(my @treadmill_entry = $sth->fetchrow_array) {
        $treadmill_entries->{total}++;
        push(@{$treadmill_entries->{rows}}, { id => $treadmill_entry[0],
            date => $treadmill_entry[1],
			duration => $treadmill_entry[2],
            energy => $treadmill_entry[3],
            distance => $treadmill_entry[4],
            user_name => $users->{$treadmill_entry[5]},
			user_id => $treadmill_entry[6],
        });
    }
    $sth->finish;

    $self->render(json => $treadmill_entries);
}

# this is used to the the user name to a user id. The client sends just the id and this id is saved in the db
# So if the clients requested all treadmill entries I look for the user name here to show the user the name instead of the id.
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

# this method is called by the /get_users route.
# Te client side calls this to get all users and show them in the datagrid user combobox.
sub get_users {
    my $self = shift;
    my $db = $self->app->db;

    my $users = [];
    my $sth = $db->prepare('SELECT user_id, user_name FROM datauser');
    $sth->execute;
    while(my @user = $sth->fetchrow_array) {
        push($users, {user_id => $user[0], user_name => $user[1]});
    }
    $sth->finish;

    $self->render(json => $users);
}

sub add_tm {
    my $self = shift;
    my $db = $self->app->db;

    my $id = $self->param('id');
    my $date = $self->param('date') // undef;
	my $duration = $self->param('duration') // undef;
    my $energy = $self->param('energy') // undef;
    my $distance = $self->param('distance') // undef;
    my $user_id = $self->param('user_id') // undef;

    say "id ", $id;
    say "date ", $date;
	say "duration", $duration;
    say "energy ", $energy;
    say "distance ", $distance;
    say "user id ", $user_id;

    return $self->render(json => { error => 1, error_msg => "date not set" }) unless $date =~ /\w+/;;
	return $self->render(json => { error => 1, error_msg => "duration not set" }) unless $duration =~ /\d+/;
    return $self->render(json => { error => 1, error_msg => "energy not set" }) unless $energy =~ /\d+/;
    return $self->render(json => { error => 1, error_msg => "distance not set" }) unless $distance =~ /\d+\.?\d+/;
    return $self->render(json => { error => 1, error_msg => "user id not set" }) unless $user_id =~ /\d+/;
    
    if(-1 != $id) {
        $db->do('UPDATE treadmill SET treadmill_date = ?, treadmill_duration = ?, treadmill_energy = ?, treadmill_distance = ?, treadmill_user_id = ? WHERE treadmill_id = ?', undef, $date, $duration, $energy, $distance, $user_id, $id);
    }
    else {
        $db->do('INSERT INTO treadmill(treadmill_date, treadmill_duration, treadmill_energy, treadmill_distance, treadmill_user_id) VALUES(?,?,?,?,?)', undef, $date, $duration, $energy, $distance, $user_id);
    }

    $self->render(json => "OK");
}

sub remove_tm {
    my $self = shift;
    my $db = $self->app->db;

    my $id = $self->param('id');
    say "remove id ", $id;
    
    if(-1 != $id) {
        $db->do('DELETE FROM treadmill WHERE treadmill_id = ?', undef, $id);
    }

    $self->render(json => "OK");
}

1;
