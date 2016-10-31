require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:rev) do
    req = Requester.create({ rname: 'datname', rid: 'A931LK1SDF8' })
    hit = Hit.create({ title: 'dat hit bb', reward: 0.33, requester: req })
    rev = Review.create({ hit: hit, tos: 1, tos_context: '3rd party sign up', broken: 0, deceptive: 0, completed: 'none', context: 'uhhh' })
    Comment.create({ review: rev, body: 'such comment! v excite' })
    Comment.create({ review: rev, body: 'terrible review; 1 out of 7 stars' })
    rev
  end

  it 'properly associates with the root node (requester)' do
    expect(rev.hit.title).to eq('dat hit bb')
    expect(rev.hit.requester.rname).to eq('datname')
  end
  it 'associates with comments' do
    expect(rev.comments.size).to eq(2)
  end
end
