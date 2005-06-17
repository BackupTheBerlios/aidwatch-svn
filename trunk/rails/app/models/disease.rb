class Disease < ActiveRecord::Base
  include ApplicationHelper
  def diseaseName() diseaseNames[discat] end
  validates_presence_of :discat
  validates_inclusion_of :discat, :in=>0..10
  validates_inclusion_of :numcases, :in=>1..8000000000
end
