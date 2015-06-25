package DataOnWeb::Controller::Treadmill;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub show {
    my $self = shift;

}

sub all_tm {
    my $self = shift;
    my $db = $self->app->db;

    # Render template "example/welcome.html.ep" with message
    my $sth = $db->prepare("SELECT * FROM treadmill");
    $sth->execute;
    my $treadmill_entries = { total => 0, rows => [] };
    while(my @treadmill_entry = $sth->fetchrow_array) {
        $treadmill_entries->{total}++;
        push(@{$treadmill_entries->{rows}}, { id => $treadmill_entry[0],
            date => $treadmill_entry[1],
            energy => $treadmill_entry[2],
            distance => $treadmill_entry[3],
            user_id => $treadmill_entry[4],
        });
    }
    $sth->finish;

    $self->render(json => $treadmill_entries);
}

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
    my $date = $self->param('date');
    my $energy = $self->param('energy');
    my $distance = $self->param('distance');
    my $user_id = $self->param('user_id');


}

sub show_bicycle {
    my $self = shift;
    my $db = $self->app->db;
}

1;
