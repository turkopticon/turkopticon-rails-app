class ForumPostVersion < ActiveRecord::Base

  def person
    Person.find(self.person_id)
  end

  def author_name
    person.public_email
  end

end
