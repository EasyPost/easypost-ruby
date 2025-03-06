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
coverage: test

## docs - Generate documentation for the library
docs:
	bundle exec rdoc lib -o docs --title "EasyPost Ruby Docs"

## install-styleguide - Import the style guides (Unix only)
install-styleguide: | init-examples-submodule
	sh examples/symlink_directory_files.sh examples/style_guides/ruby .

## init-examples-submodule - Initialize the examples submodule
init-examples-submodule:
	git submodule init
	git submodule update

## install - Install globally from source
install: | init-examples-submodule
	bundle install

## lint - Lint the project
lint: rubocop scan

## lint-fix - Fix Rubocop errors
lint-fix: rubocop-fix

## publish - Publishes the built gem to Rubygems
publish:
	gem push dist/*.gem

## release - Cuts a release for the project on GitHub (requires GitHub CLI)
# tag = The associated tag title of the release
# target = Target branch or full commit SHA
release:
	gh release create ${tag} dist/* --target ${target}

## rubocop - lints the project with rubocop
rubocop:
	bundle exec rubocop

## rubocop-fix - fix rubocop errors
rubocop-fix:
	bundle exec rubocop -a

## scan - Runs security analysis on the project with Brakeman
scan:
	bundle exec brakeman lib --force

## test - Test the project (and ignore warnings for test output)
test:
	bundle exec rspec

## update - Updates dependencies
update: | update-examples-submodule

## update-examples-submodule - Update the examples submodule
update-examples-submodule:
	git submodule init
	git submodule update --remote

.PHONY: help build clean coverage docs install install-styleguide lint lint-fix publish release rubocop rubocop-fix scan test update update-examples-submodule
