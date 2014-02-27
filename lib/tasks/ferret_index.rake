desc "Updates the ferret index for the application."

#`GEM_PATH=/home/rahrahfe/.gem/:/usr/lib/ruby/gems/1.8`
puts `env`

task :ferret_index => [ :environment ] do | t |
  Report.rebuild_index
  Requester.rebuild_index
  # here I could add other model index rebuilds
  puts "Completed Ferret Index Rebuild"
end