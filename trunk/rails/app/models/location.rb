class Location < ActiveRecord::Base
  def to_s
#    myself = "#{name}|"
#    mykids = [ ]
#    children.each { |k|
#      mykids << k.to_s
#    }
#    myself + ":("+mykids.join(",")+") "
    "#{fullcode}:#{name}"
  end

  def self.convertCodeToLoc(fullcode)
    results = Location.find_all(["fullcode = ?", fullcode])
    raise "bad location code #{fullcode}" if results.size != 1
    results[0]
  end

  def htmlName
    n = "(#{fullcode}:#{name})"
    n = "#{n}..." unless isLeafNode?
    n = "<b>#{n}</b>" if isAffectedRegion?
    n
  end

  def isLeafNode?()
    flags & 1 != 0
  end
  def setLeafNode()
    flags |= 1
  end
  def resetLeafNode()
    flags &= ~1
  end
  def isAffectedRegion?()
    flags & 2 != 0
  end
	def hasParent?()
		parent > 0
	end
  def addChild(who)
    who.parent = self.id
    who.resetLeafNode
    who.save
    self.save
  end
  def canDelete?()
    isLeafNode? && children.size == 0
    #isLeafNode?
  end
  def children()
    Location.find_all(["parent = ?", id], 'name ASC')
  end
  def self.table_name() "locations" end

end
