class Pet < ActiveRecord::Base
  belongs_to :kennel
  def updateSearchStuff()
    self.searchstuff =
      [ animaltype, breed, petname ].join(' ').downcase
    self.save
  end
end
