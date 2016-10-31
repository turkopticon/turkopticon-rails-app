# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#   
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def seed
  7.times do
    Person.create({ email: "#{rand_rid}@test.com" })
  end

  10.times do
    req = Requester.create({ rname: rand_rname, rid: rand_rid })
    rand(1..5).times do
      hit = create_hit(req)
      rand(1..7).times do
        usr = Person.order('RAND()').take
        rev = create_review(hit, usr)
        rand(0..2).times do
          create_comment(rev, Person.where.not(id: usr.id).order('RAND()').take)
        end
      end
    end
  end
end

def create_hit(req_ref)
  Hit.create({ title: rand_title, reward: rand_reward, requester: req_ref })
end

def create_review(hit_ref, usr_ref)
  Review.create({ hit: hit_ref, person: usr_ref, tos: [true, false].sample, tos_context: 'requires 3rd party registration', broken: [true, false].sample, broken_context: "'contintue' buttons didn't work", deceptive: 0, completed: 'none', context: lorem })
end

def create_comment(rev_ref, usr_ref)
  Comment.create({ review: rev_ref, person: usr_ref, body: 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Morbi lacinia molestie dui.' })
end

def rand_rid
  'A' << [*('A'..'Z'), *(0..9)].shuffle[0, 10].join
end

def rand_rname
  set = %w( Panamera Lemma Integurl Mushiva Rawrllgrrr Bodyleak Institute Polymer Odesza Sabinnom Savage Lettuce Osiris )
  set.sample(rand(1..3)).join(' ')
end

def rand_title
  set = %w( porttitor suscipit consequat praesent rhoncus lacus augue eu feugiat lorem feugiat nec suspendisse id felis quis odio luctus molestie massa suspendisse tincidunt blandit purus porta finibus )
  set.sample(rand(4..7)).join(' ')
end

def rand_reward
  '%3.2f' % rand(0.0..1.8)
end

def lorem
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras eget orci sed sem placerat aliquam. Aliquam venenatis leo non sodales fermentum. Nulla in accumsan ipsum. Fusce blandit, nisi eu viverra euismod, sem arcu tincidunt enim, sagittis dapibus dolor sapien et est. Proin euismod tempor ante in maximus. Donec a pretium erat. Vestibulum vel felis pretium, imperdiet dui a, bibendum felis.'
end

seed