require 'csv'

def sqlesc(str)
  str = str.clone
  str.gsub!(/\\/,'\\\\\\')
  str.gsub!(/[']/,'\\\\\'')
  str.gsub!(/[\n\r]+/,'/')
  "'#{str}'"
end

class Hash
  def overwrite(k)
    self[k] = yield self[k]
  end
end

def writeSQL(rowhash)
  keys = []
  vals = []
  %w[ person_record_id entry_date author_name author_email author_phone source_name source_date source_url first_name last_name home_street home_city home_state home_zip photo_url home_neighborhood note_record_id misctext other ].sort.each_with_index { |k,i|
      keys[i] = k
      vals[i] = sqlesc(rowhash[k].to_s)
  }
  parenkeynames = "(#{keys.join(',')})"
  vals = "(#{vals.join(',')})"
  sql = "INSERT INTO people #{parenkeynames} VALUES #{vals};"
  puts sql
end

 
csvfile = CSV::Reader.create(File.open('data.csv', 'rb'))
header = [ ]
csvfile.shift.each do |key|
  header << key.gsub(/ /,'_').downcase
end

hdrmap = { "text" => "misctext", "city" => "home_city", "state/province" => "home_state", "zip/postal_code" => "home_zip", "street_line1" => "home_street", "street_line2" => "home_street", "street_line3" => "home_street" }

csvfile.each do |row|
  rowhash = { }
  header.each_with_index { |hdr,i|
    hdr = hdrmap[hdr] if hdrmap[hdr]
    rowhash[hdr] ||= []
    rowhash[hdr] << row[i]
  }
  rowhash.overwrite('home_street') { |i| i.join(' ') }
  writeSQL rowhash
end

  
