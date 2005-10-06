class Pet < ActiveRecord::Base
  def updateSearchStuff()
    self.searchstuff =
      [ animaltype, breed, petname ].join(' ').downcase
    self.save
  end
end
