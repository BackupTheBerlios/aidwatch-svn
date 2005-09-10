require "ncd_util"

class Phonenum < ActiveRecord::Base

  def searchGoo()
    vals = ['name', 'notes', 'loc'].map { |i| eval "self.#{i}" }
    vals.join(' ')
  end

  def relevanceTo(str)
    1.0 - NCDUtil.ncd(str, searchGoo())
  end

  def relevance=(r) @relevance = r end
  def relevance() @relevance || 0.0  end
	def adjustMatch() NCDUtil.updateApproxStr(self, 'name') end

	validates_presence_of :name, :dialcode, :cat
	validates_length_of :name, :minimum => 2
	validates_length_of :dialcode, :minimum => 2
	validates_uniqueness_of :name

end
