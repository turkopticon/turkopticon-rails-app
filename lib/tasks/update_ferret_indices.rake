task :update_ferret_indices => [ :environment ] do |t|
  reqs = Requester.find(:all, :conditions => ["created_at > ?", Time.now - 25.hours])
  reqs.each{|r| r.ferret_update}
  puts "Added #{reqs.length.to_s} Requester objects to index."
  reps = Report.find(:all, :conditions => ["created_at > ?", Time.now - 25.hours])
  reps.each{|r| r.ferret_update}
  puts "Added #{reps.length.to_s} Report objects to index."
end