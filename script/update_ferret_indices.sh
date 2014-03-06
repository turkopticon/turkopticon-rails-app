#!/usr/bin/env bash

# load rvm ruby
source /home/ssilberman/.rvm/environments/ruby-1.8.7-p374@turkopticon-production

cd /home/ssilberman/src/turkopticon/
RAILS_ENV=production rake update_ferret_indices
