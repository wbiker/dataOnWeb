package DataOnWeb;
use Mojo::Base 'Mojolicious';
use Mojolicious::Plugin::Database;
use Mojolicious::Plugin::Authentication;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');
  $self->plugin('database', {
      dsn => 'dbi:SQLite:dbname=dataOnWeb.sqlite',
      username => '',
      password => '',
      options => { 'foreign_keys' => 1, 'auto_vacuum' => 1 },
      helper => 'db',
      });

    $self->plugin('authentication', {
        autoload_user => 1,
        load_user => sub {
            my $self = shift;
            my $uid = shift;

            return "wolf";
        },
        validate_user => sub {
            my $self = shift;
            my $uid = shift // '';
            my $pw = shift // '';
            my $extra = shift // {};
            use Authen::Simple::DBI;

            my $authDB = Authen::Simple::DBI->new(
                dsn => 'dbi:SQLite:dbname=dataOnWeb.sqlite',
                username => '',
                password => '',
                statement => 'SELECT userpw FROM datacredentials WHERE userid = ?',
                );
            return $uid if ($authDB->authenticate($uid, $pw));

            return undef;
        },
    });
    $self->plugin('config');

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('data#show');
  $r->get('/treadmill')->to('data#show_treadmill');
  $r->get('/bicycle')->to('data#show_bicycle');
}

1;
