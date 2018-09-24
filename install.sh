#! /bin/bash
UNICORN_INSTALLED=$(cat Gemfile | grep "gem 'unicorn'" | wc -l)
if [ "$UNICORN_INSTALLED" -lt 1 ]; then
    echo "Less than 1"
else
    echo "Unicorn Installed: $UNICORN_INSTALLED"
fi
