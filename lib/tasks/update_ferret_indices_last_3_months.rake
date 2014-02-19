task :update_ferret_indices_last_3_months => [ :environment ] do |t|
  reqs = Requester.find(:all, :conditions => ["created_at > ?", Time.now - 3.months])
  reqs.each{|r| r.ferret_update}
  puts "Added #{reqs.length.to_s} Requester objects to index."
  reps = Report.find(:all, :conditions => ["created_at > ?", Time.now - 3.months])
  reps.each{|r| r.ferret_update}
  puts "Added #{reps.length.to_s} Report objects to index."
end