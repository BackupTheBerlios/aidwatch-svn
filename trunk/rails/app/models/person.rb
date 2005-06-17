class Person < ActiveRecord::Base
  def searchGoo()
    vals = ['name', 'speclostplace'].map { |i| eval "self.#{i}" }
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
  validates_presence_of :origcode
#  validates_uniqueness_of :name
  validates_inclusion_of :sex, :in=>0..2
  validates_inclusion_of :status, :in=>0..4
#  validates_format_of :origcode, :with => /^[a-z][a-z]$/i
  validates_length_of :name, :minimum => 3
  validates_length_of :origcode, :minimum => 2
#  validates_length_of :notes, :maximum => 255
#  validates_length_of :mednotes, :maximum => 255
#  validates_length_of :emails, :maximum => 255
#  validates_format_of :famemail, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, :on => :create

end
