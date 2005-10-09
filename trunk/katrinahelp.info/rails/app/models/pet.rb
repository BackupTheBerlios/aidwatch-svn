class Pet < ActiveRecord::Base
  belongs_to :kennel
  has_many :watch
  @@ANIMALTYPES = [ "dog", "cat", "equine", "barnyard", "bird",
                    "reptile", "sm. mammal"]
  @@SIZES       = [ "small (less than 20 lbs.)", "medium (20 to 50 lbs.)",
                    "large (50 to 100 lbs.)", "extra-large (100+ lbs.)" ]
  @@COATTYPES =   [ "short-haired", "long-haired", "wire", "curly" ]
  @@COLORS    =   [ "black", "brown", "white", "gray", "tan", "gold/yellow",
                    "red", "calico", "multi"]
  @@PETDEFAULTS = {
                    :isneutered => "Unknown",
                    :gender => "Unknown",
                    :ismixed => "Unknown",
                  }
  def updateSearchStuff()
    self.searchstuff =
      [ animaltype, breed, petname, color, coat, gender, markings, lastlocal,
      lastdetail ].join(' ').downcase
    self.save
  end

  def Pet.new_with_defaults
    Pet.new(@@PETDEFAULTS)
  end

  def Pet.coattypes() @@COATTYPES end
  def Pet.animaltypes() @@ANIMALTYPES end
  def Pet.colors() @@COLORS end
  def Pet.sizes() @@SIZES end

  validates_presence_of :animaltype, :color, :gender
end
