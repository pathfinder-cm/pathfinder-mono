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

1. Ensure that you have ruby and `bundler` gem installed 
2. Clone this repo and type `bundle install` within it
3. Install PostgreSQL and setup appropriate user
4. Copy `.env.sample` to `.env`, modify the content as necessary
5. Run `rails db:setup`
6. Start the server by typing `rails s`

## Getting Help

If you have any questions or feedback regarding pathfinder-mono:

- [File an issue](https://github.com/pathfinder-cm/pathfinder-mono/issues/new) for bugs, issues and feature suggestions.

Your feedback is always welcome.

### Running Tests

Run `rspec spec`

## Additional Documentations

See `doc` directory.

## Further Reading

- [Pathfinder Container Manager Wiki][pathfinder-cm-wiki]

[pathfinder-cm-wiki]: https://github.com/pathfinder-cm/wiki

## License

Apache License v2, see [LICENSE](LICENSE).
