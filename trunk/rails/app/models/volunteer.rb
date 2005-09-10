require "ncd_util"
class Volunteer < ActiveRecord::Base

  def searchGoo()
    vals = ['name', 'notes', 'targetagency', 'skilldesc'].map { |i| eval "self.#{i}" }
    vals.join(' ')
  end

  def relevanceTo(str)
    1.0 - NCDUtil.ncd(str, searchGoo())
  end

  def relevance=(r) @relevance = r end
  def relevance() @relevance || 0.0  end
	def adjustMatch() NCDUtil.updateApproxStr(self, 'name') end

  def safeAge() age || -1 end
  validates_presence_of :name
  validates_presence_of :origcode, :message => ": please select a country"
  validates_inclusion_of :sex, :in=>0..2
  validates_inclusion_of :skillcat, :in=>0..5
  validates_inclusion_of :canpay, :in=>0..2
#  validates_format_of :origcode, :with => /^[a-z][a-z]/i, :message => ": invalid country"
  validates_length_of :origcode, :minimum => 2 
  validates_length_of :name, :minimum => 3
  validates_length_of :targetagency, :maximum => 255
  validates_length_of :skilldesc, :maximum => 255
#  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, :on => :create, :message => " address required"
end
