# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#   
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def seed
  8.times do
    Person.create({ email: "#{rand_rid}@test.com" })
  end

  10.times do |i|
    puts i
    aka = alter_ego
    req = Requester.create({ rname: rand_rname, rid: rand_rid, aliases: aka })
    rand(1..5).times do
      hit = create_hit(req)
      rand(1..7).times do
        # sleep 1 # for timestamps
        usr = Person.order('RAND()').take
        rev = create_review(hit, usr)
        rand(0..2).times do
          create_comment(rev, Person.where.not(id: usr.id).order('RAND()').take)
        end
      end
    end
  end
end

def alter_ego
  if rand > 0.8
    [rand_rname, rand_rname]
  else
    rand > 0.5 ? [rand_rname] : nil
  end
end

def create_hit(req_ref)
  Hit.create({ title: rand_title, reward: rand_reward, requester: req_ref })
end

def create_review(hit_ref, usr_ref)
  tos, broken, deceptive = Array.new(3).map { [false, true, false, false].sample }
  tc                     = tos ? 'requires 3rd party registration' : nil
  bc                     = broken ? "'continue' buttons didn't work" : nil
  dc                     = deceptive ? 'claimed 5 minute survey; actually took 15' : nil
  comp                   = %w(none one many).sample
  rej                    = comp != 'none' ? %w(n/a no yes).sample : nil
  time                   = comp != 'none' ? rand((3*60)..(20*60)) : nil
  tp                     = comp != 'none' ? rand(6.hour .. 10.day) : nil
  Review.create({ hit: hit_ref, person: usr_ref, tos: tos, tos_context: tc, broken: broken, broken_context: bc, deceptive: deceptive, deceptive_context: dc, completed: comp, time: time, time_pending: tp, rejected: rej, context: lorem })
end

def create_comment(rev_ref, usr_ref)
  Comment.create({ review: rev_ref, person: usr_ref, body: 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Morbi lacinia molestie dui.' })
end

def rand_rid
  'A' << [*('A'..'Z'), *(0..9)].shuffle[0, 10].join
end

def rand_rname
  set = %w( Panamera Lemma Shockolate Bazeev Paragon Mushiva Rawrllgrrr Bodyleak Erodisi Polymer Odesza Sabinnom Savage Forxst Osiris Ethos R&D Rhian Einaudi )
  set.sample(rand(1..4)).join(' ')
end

def rand_title
  set = %w( porttitor suscipit consequat praesent rhoncus lacus augue eu feugiat lorem feugiat nec suspendisse id felis quis odio luctus molestie massa suspendisse tincidunt blandit purus porta finibus )
  set.sample(rand(4..7)).join(' ')
end

def rand_reward
  '%.2f' % rand(0.0..1.8)
end

def lorem
  ['Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras eget orci sed sem placerat aliquam. Aliquam venenatis leo non sodales fermentum. Nulla in accumsan ipsum. Fusce blandit, nisi eu viverra euismod, sem arcu tincidunt enim, sagittis dapibus dolor sapien et est. Proin euismod tempor ante in maximus. Donec a pretium erat. Vestibulum vel felis pretium, imperdiet dui a, bibendum felis.',
   'Etiam quis diam ut orci dignissim viverra. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nullam maximus fringilla felis, accumsan tempus dolor auctor vel.',
   'Donec pulvinar sed velit gravida rutrum. Integer nec lacinia mi. Nullam metus sapien, mollis interdum laoreet a, tristique id leo.',
   'Aliquam libero augue, sagittis id dolor at, volutpat cursus est. Proin ullamcorper est eget arcu suscipit malesuada. Maecenas egestas eleifend faucibus. Aenean libero justo, pellentesque et mauris vel, dictum fringilla risus. Maecenas auctor vitae lectus vitae tempor. Morbi sodales gravida nibh nec lobortis.'].sample
end

seed