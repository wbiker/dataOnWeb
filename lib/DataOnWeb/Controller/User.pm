package DataOnWeb::Controller::User;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub list_users {
    my $self = shift;

	# the view will be send to client together with java script code which will fetch all users
	# with the get_users route
}

sub get_users {
	my $self = shift;
	my $db = $self->app->db;

    my $user_entries = { total => 0, rows => []};
    my $sth = $db->prepare("SELECT * FROM datauser");
    $sth->execute;
    while(my $user_entry = $sth->fetchrow_array) {
		$user_entries->{total}++;
        push(@{$user_entries->{rows}}, { id => $user_entry->[0],
            name => $user_entry->[1],
        });
    }
    $sth->finish;

    $self->render(json => $user_entries);
}

sub add_user {
    my $self = shift;
    my $db = $self->app->db;

    # Render template "example/welcome.html.ep" with message
}

sub remove_user {
    my $self = shift;
    my $db = $self->app->db;
}

1;
