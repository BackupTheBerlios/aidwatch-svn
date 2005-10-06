class Pet < ActiveRecord::Base
  has_one :kennel
  def updateSearchStuff()
    self.searchstuff =
      [ animaltype, breed, petname ].join(' ').downcase
    self.save
  end
end
