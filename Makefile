## help - Display help about make targets for this Makefile
help:
	@cat Makefile | grep '^## ' --color=never | cut -c4- | sed -e "`printf 's/ - /\t- /;'`" | column -s "`printf '\t'`" -t

## build - Builds the project
build:
	gem build easypost.gemspec --strict
	mkdir -p dist
	mv *.gem dist/

## clean - Cleans the project
clean:
	rm -rf coverage doc *.gem dist

## coverage - Generate a test coverage report
coverage:
	make test

## docs - Generate documentation for the library
docs:
	bundle exec rdoc lib -o docs --title "EasyPost Ruby Docs"

## format - Fix Rubocop errors
format:
	bundle exec rubocop -a

## install-styleguide - Import the style guides (Unix only)
install-styleguide: | update-examples-submodule
	sh examples/symlink_directory_files.sh examples/style_guides/ruby .

## install - Install globally from source
install: | update-examples-submodule
	bundle install

## update-examples-submodule - Update the examples submodule
update-examples-submodule:
	git submodule init
	git submodule update --remote

## lint - Lint the project
lint:
	bundle exec rubocop

## publish - Publishes the built gem to Rubygems
publish:
	gem push dist/*.gem

## release - Cuts a release for the project on GitHub (requires GitHub CLI)
# tag = The associated tag title of the release
release:
	gh release create ${tag} dist/*

## scan - Runs security analysis on the project with Brakeman
scan:
	bundle exec brakeman lib --force

## test - Test the project (and ignore warnings for test output)
test:
	bundle exec rspec

## update - Updates dependencies
update: | update-examples-submodule

.PHONY: help build clean coverage docs format install install-styleguide lint publish release scan test update update-examples-submodule
