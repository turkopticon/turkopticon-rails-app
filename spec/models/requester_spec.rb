require 'rails_helper'

RSpec.describe Requester, type: :model do
  # let (:req) { Requester.create({rname: 'da req', rid: 'A1234'}) }

  it 'fails to create new entry with duplicate requester id' do
    Requester.create({ rname: 'da req', rid: 'A1234' })
    dup = Requester.create({ rname: 'da dup', rid: 'A1234' })
    expect(dup.id).to be_nil
  end
end
