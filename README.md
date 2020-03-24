# Pathfinder Mono

API server and scheduler for Pathfinder container manager.

Read the details on our wiki, [here][pathfinder-cm-wiki].

## Quick Setup

1. Ensure you have vagrant installed
2. Clone this repo `git clone https://github.com/pathfinder-cm/pathfinder-mono.git`
2. Enter directory that you just cloned and type `vagrant up --provision`

Now you can either open `http://192.168.33.33:8080` or do `vagrant ssh` and type `pfi get nodes`. For full list of commands, type `pfi help`.

> Default username `admin` and password `pathfinder`

## Development Setup

Clone this repository and install all deployment requirements on your machine:
1. [Docker](https://docker.com)
2. [docker-compose](https://docs.docker.com/compose)

Build the Docker development image. It must also be rebuilt for changes in `Gemfile` or` Gemfile.lock`.
```
docker-compose build
```

Start the server in background. The server will listen on `localhost:3000` so make sure that no one is listening on it.
```
docker-compose up -d
```

Prepare the database. The server cannot be accessed before setting up the database.
```
docker-compose exec web bundle exec rails db:setup
```

The development activities can be carried out by following this pattern:
1. Write a [RSpec](https://rspec.info) test in `spec/` directory.
2. Write the implementation and refactor if needed.

To run the test:
```
docker-compose exec web bundle exec rspec
```

To open Rails console on development environment:
```
docker-compose exec web bundle exec rails c
```

Changes inside the development environment will be reflected to the working directory, and vice versa. So, Rails generator can be run inside the development environment. An example of it would be:
```
docker-compose exec web bundle exec rails g migration add_last_error_at_to_deployments last_error_at:datetime
```

Sometimes, you need to clean the development environment. To destroy the development environment:
```
docker-compose down
```

## Getting Help

If you have any questions or feedback regarding pathfinder-mono:

- [File an issue](https://github.com/pathfinder-cm/pathfinder-mono/issues/new) for bugs, issues and feature suggestions.

Your feedback is always welcome.

## Additional Documentations

See `doc` directory.

## Further Reading

- [Pathfinder Container Manager Wiki][pathfinder-cm-wiki]

[pathfinder-cm-wiki]: https://github.com/pathfinder-cm/wiki

## License

Apache License v2, see [LICENSE](LICENSE).
