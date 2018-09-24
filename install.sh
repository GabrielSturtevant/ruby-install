#! /bin/bash
UNICORN_INSTALLED=$(cat Gemfile | grep "gem 'unicorn'" | wc -l)
if [ "$UNICORN_INSTALLED" -lt 1 ]; then
    echo "Adding unicorn to Gemfile"
    echo "gem 'unicorn'" >> Gemfile
fi
