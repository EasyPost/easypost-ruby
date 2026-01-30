# Builds the project
build:
    gem build easypost.gemspec --strict
    mkdir -p dist
    mv *.gem dist/

# Cleans the project
clean:
    rm -rf coverage doc *.gem dist

# Generate a test coverage report
coverage:
    just test

# Generate documentation for the library
docs:
    bundle exec rdoc lib -o docs --title "EasyPost Ruby Docs"

# Import the style guides (Unix only)
install-styleguide: init-examples-submodule
    sh examples/symlink_directory_files.sh examples/style_guides/ruby .

# Initialize the examples submodule
init-examples-submodule:
    git submodule init
    git submodule update

# Install globally from source
install: init-examples-submodule
    bundle install

# Lint the project
lint: rubocop scan

# Fix Rubocop errors
lint-fix: rubocop-fix

# Publishes the built gem to Rubygems
publish:
    gem push dist/*.gem

# Cuts a release for the project on GitHub (requires GitHub CLI)
# tag = The associated tag title of the release
# target = Target branch or full commit SHA
release tag target:
    gh release create {{tag}} dist/* --target {{target}}

# Lints the project with rubocop
rubocop:
    bundle exec rubocop

# Fix rubocop errors
rubocop-fix:
    bundle exec rubocop -a

# Runs security analysis on the project with Brakeman
scan:
    bundle exec brakeman lib --force

# Test the project (and ignore warnings for test output)
test:
    bundle exec rspec

# Updates dependencies
update: update-examples-submodule

# Update the examples submodule
update-examples-submodule:
    git submodule init
    git submodule update --remote
