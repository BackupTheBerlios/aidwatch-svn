require 'zlib'

require 'approx'

# ProtoApprox.rb by Rudi Cilibrasi (cilibrar@ofb.net)
#



#
# Soundex.rb
#
# Implementation of the soundex algorithm as described by Knuth 
# in volume 3 of The Art of Computer Programming
#
# author:  Michael Neumann (neumann@s-direktnet.de)
# version: 1.0
# date:    26.07.2000
# license: GNU GPL
#


module Text
module Soundex

  def soundex(str_or_arr)
    case str_or_arr
    when String
      soundex_str(str_or_arr)
    when Array
      str_or_arr.collect{|ele| soundex_str(ele)}
    else
      nil
    end
  end
  module_function :soundex
  
  private

  #
  # returns nil if the value couldn't be calculated (empty-string, wrong-character)
  # do not change the parameter "str"
  #
  def soundex_str(str)
    return nil if str.empty?

    str = str.upcase
    last_code = get_code(str[0,1])
    soundex_code = str[0,1]

    for index in 1...(str.size) do
      return soundex_code if soundex_code.size == 4

      code = get_code(str[index,1])
      
      if code == "0" then
        last_code = nil
      elsif code == nil then
        return nil
      elsif code != last_code then
        soundex_code += code
        last_code = code        
      end 
    end # for
    
    return soundex_code + "000"[0,4-soundex_code.size]
  end
  module_function :soundex_str
            
  def get_code(char)
    char.tr! "AEIOUYWHBPFVCSKGJQXZDTLMNR", "00000000111122222222334556"
  end
  module_function :get_code

end # module Soundex
end # module Text

module NCDUtil
def self.fakeSoundex(str)
  downstr = normalizeString(str)
	downstr = downstr.gsub(/-/, ' ')
  strparts = downstr.split(/\s/)
  strsounds = strparts.map { |i| Text::Soundex.soundex(i) }
  strsounds.join('')
end

def self.csize(a)
  comp = Zlib::Deflate.new()
  cstr = comp.deflate(a, Zlib::FINISH)
  cstr.size * 8
end

def self.ncd(a,b)
	return 0 if a == b
  a = a.to_s
  b = b.to_s
  ca = csize(a).to_f
  cb = csize(b).to_f
  cab = csize(a+b).to_f
  arr = [ca, cb, cab].sort
  (arr[2] - arr[0]) / arr[1]
end

def self.dropRowsFromApprox(classname, fieldname, targetrow)
  Approx.destroy_all("classstr = '#{classname}' AND attribstr = '#{fieldname}' AND targetrow = #{targetrow}")
end

def self.canAcceptString?(str)
  return false if str.size <= 2
  return false if fakeSoundex(str).size <= 2
  return true
end

def self.normalizeString(str)
  str.gsub(/[^0-9a-zA-Z .-]/, '').gsub(/^\s*/,'').gsub(/\s*$/,'').downcase
end

def self.addRowToTable(str, classname, fieldname, targetrow)
  fail "Illegal fieldname #{fieldname}" unless fieldname =~ /^[a-z0-9]*$/i
  str = normalizeString(str)
  snd = fakeSoundex(str)
  fail "Cannot add short string #{str} to table" unless (str.size > 2 && snd.size > 2)
  flags = 0
  nr = Approx.new()
	nr.exactstr = str
	nr.soundexstr = snd
	nr.classstr = classname
	nr.attribstr = fieldname
	nr.targetrow = targetrow
	nr.flags = flags
  nr.save
end

def self.searchSubstring(classname, fieldname, inpstr, maxresult = 1000)
  inpstr = normalizeString(inpstr)
  fail "Illegal maxresult" unless maxresult > 0
  fail "Input string #{inpstr}: too short" unless inpstr.size > 1
	results = Approx.find_all(["classstr = ? AND attribstr = ? AND exactstr LIKE ?", classname, fieldname,inpstr])
	if results.size == 0
    results = Approx.find_all(["classstr = ? AND attribstr = ? AND soundexstr LIKE ?", classname, fieldname,"%#{fakeSoundex(inpstr)}%"])
	end
	results
end

def self.searchExact(classname, fieldname, inpstr, maxresult = 1000)
  inpstr = normalizeString(inpstr)
  fail "Illegal maxresult" unless maxresult > 0
  fail "Input string #{inpstr}: too short" unless inpstr.size > 1
	Approx.find_all(["classstr = ? AND attribstr = ? AND exactstr = ?", classname, fieldname,inpstr])
end

def self.searchApprox(classname, fieldname, inpstr, maxresult = 1000)
  fail "Illegal maxresult" unless maxresult > 0
  inpstr = normalizeString(inpstr)
  fail "Input string too short" unless inpstr.size > 2
  cand = searchExact(classname, fieldname, inpstr, maxresult)
  if cand.size ==  0
    sndinp = fakeSoundex(inpstr)
    fail "Input string too short" unless sndinp.size > 2
    cand = Approx.find_all("classstr = '#{classname}' AND attribstr = '#{fieldname}' AND soundexstr LIKE '%#{sndinp}%' LIMIT #{maxresult*10}")
    ncds = { }
    cand.each { |obj|
      exactstr = obj.exactstr
      ncds[obj.id] = ncd(inpstr, exactstr)
    }
    cand.sort! { |a,b| ncds[a.id] <=> ncds[b.id] }
  end
	if cand.size > maxresult
		cand = cand[0,maxresult]
	end
  cand
end

def self.updateApproxStr(targetobj, fieldname)
  str = eval "targetobj.#{fieldname}.to_s"
  classname = targetobj.class.name
  snd = fakeSoundex(str)
  targetid = targetobj.id
  dropRowsFromApprox(classname, fieldname, targetid)
  addRowToTable(str, classname, fieldname, targetid)
end

end  # module NCDUtil
