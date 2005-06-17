# The methods added to this helper will be available to all templates in the application.

require 'wavedb_utils'
module ApplicationHelper
  @@YEARS = ['2005','2006','2007','2008','2009','2010']
  @@MONTHS = ['January','February','March','April','May','June','July','August','September','October','November','December']
#  include ActionView::Helpers
  include WaveDBUtils
  def pageOptionString()
    opts = [ ]
    if pager
      if pager.pagecount > 1
        opts << link_to('Prev page', :action => "doPrevPage")
        opts << link_to('Next page', :action => "doNextPage")
      end
      if pager.pagecount > 3
        opts << link_to('First page', :action => "doFirstPage")
        opts << link_to('Last page', :action => "doLastPage")
      end
    end
    opts.join(' | ')
  end
  def pageResultsCount()
    return '' unless pager
    return " | <strong>Page #{pager.friendlyPagenum}/#{pager.pagecount} displaying #{ pager.curpage.size} of #{ pager.size} total.</strong></td></tr>"
  end
  def htmlColumn(str)
   "<td NOWRAP id=\"blackline\"><strong>#{pager.htmlAnnotate(@controller, str)}</strong></td>"
  end
  def allHtmlColumns()
    cols = pager.allColumnsOriginalOrder.map { |i| htmlColumn(i) }
    cols.join("\n")
  end
  def fullPageStatus()
    pageOptionString + pageResultsCount
  end
  def pager() @controller.getPager end
  def optionList(promptstrorcurval, selname, choices, showZeroChoice = true, unknownKey = 0)
    cv = promptstrorcurval.to_s
    cvk = nil
    cvv = nil
    if (cv =~ /^\d+$/ || cv =~ /^[a-z][a-z]$/i)
      cvk = cv
      cvk = cvk.to_i if choices.is_a?(Array) && cvk =~ /^\d+$/
      cvv = choices[cvk]
      fail "unknown key #{cv}" unless cvv
    end
    unless cvv
      cvk = ''
      cvv = cv
    end
    choicearray = [ ]
    if choices.is_a?(Hash)
      choices.each { |k,v| choicearray << [k, v] }
    else
      choices.each_with_index { |v, k| choicearray << [k, v] }
    end
    optlist = [ ]
    choicearray.sort! { |a,b| a[1] <=> b[1] }
    choicearray.unshift([cvk, cvv])
    choicearray.each { |k, v|
      next if (!showZeroChoice && unknownKey == k)
      ostr = "<option value=\"#{k}\">#{v}<br>"
      optlist << ostr
    }
    <<EOF
<select name="#{selname}">
#{optlist.join("\n")}
</select>
EOF
  end
  class FlippableSortKey
    attr_reader :str, :symbol, :parity
    def initialize(str, symbol = str.downcase)
      @str = str
      @symbol = symbol.to_s
      @parity = symbol.to_s == 'relevance' ? -1 : 1
    end
    def isMatchingKey?(s) s == str || s == symbol end
    def flip() @parity *= -1 end
    def sortout(a,b)
      ((a.send(symbol) || '') <=> (b.send(symbol) || '')) * parity
    end
  end
  class SortableTableHelper
    def initialize(*args)
      @cl = args.shift
      @ordering = args.clone
      @origorder = @ordering.map { |i| i.str }
      fail "Must have class object not #{@cl}" unless @cl.is_a?(Class)
    end
    def allColumnsOriginalOrder() @origorder end
    def sortout(a,b)
      @ordering.each { |i|
        cur = i.sortout(a,b)
        return cur if cur != 0
      }
      return 0
    end
    def findStr(str)
      @ordering.each_index { |i|
        return @ordering[i] if @ordering[i].str == str
      }
    end
    def parstr(str)
      findStr(str).parity == 1 ? ' v' : '  ^'
    end
    def major() @ordering[0] end
    def htmlAnnotate(con, str)
      linkname = annotate(str)
      linktarget = con.url_for( { :action => 'choseItem', :params => { 'fieldname' => str, 'oldaction' => 'list' } } )
      "<a href='#{linktarget}'>#{linkname}</a>"
    end
    # first parameter string table column name
    # optional second symbol parameter
    def annotate(str)
      return "#{str}'#{parstr(str)}" if @ordering[0].isMatchingKey?(str)
      return "#{str}\"#{parstr(str)}" if @ordering[1].isMatchingKey?(str)
      return str + parstr(str)
    end
    def choseItem(str)
      @ordering.each { |i|
        if i.isMatchingKey?(str)
          if i == @ordering[0]
            i.flip
          else
            @ordering.delete(i)
            @ordering.unshift(i)
          end
          return
        end
      }
      fail "bad symbol #{symbol}"
    end
  end

  # Takes a Time object or nil, and returns a String in yyyy-mm-dd format
  # or "unspecified" for nil.
  def printHTMLDateShort(tobj)
    return alStrftime(tobj,'%y-%m-%d')
  end

  # Takes a Time object or nil, and returns a Strong in "monthname day, year"
  # format or "unspecified" for nil.
  def printHTMLDateLong(tobj)
    return alStrftime(tobj,'%B %d, %Y')
  end

  # Seems there's a but in Ruby strftime
  def alStrftime(tobj, str)
   return "unspecified" unless tobj
   return tobj.strftime(str)
  end
  @@DISEASECATEGORIES = ['unknown','Cholera','Typhoid','Malaria','Dengue Fever','Measles','Pneumonia','Dysentery','Filariasis','Meningitis','Tuberculosis']
  @@SUPPLYSTATUSCATEGORIES = ['unknown','Requested', 'Shipped', 'Received', 'Depleted' ]
  @@CATEGORYNAMES = ['unspecified','Relief Organization','Aid Worker','Volunteer Group','Potential Volunteer','Donor','Supplier','Government','Hospital','Other']
  @@SKILLNAMES = [ 'unspecified','Medical','Logistic','Construction','Other, please specify','Online Volunteer' ]
  @@CANPAYNAMES = [ 'unspecified', 'Yes', 'No' ]
  @@STATUSNAMES = [ 'unspecified','Alive','Dead','Injured','Missing']
  @@SEXNAMES = ['unspecified','Male','Female']
  @@COUNTRYNAMES = { "AF" => "Afghanistan","AL" => "Albania","DZ" => "Algeria","AS" => "American Samoa","AD" => "Andorra","AG" => "Angola","AI" => "Anguilla","AG" => "Antigua & Barbuda","AR" => "Argentina","AA" => "Armenia","AW" => "Aruba","AU" => "Australia","AT" => "Austria","AZ" => "Azerbaijan","AP" => "Azores","BS" => "Bahamas","BH" => "Bahrain","BD" => "Bangladesh","BB" => "Barbados","BY" => "Belarus","BE" => "Belgium","BZ" => "Belize","BJ" => "Benin","BM" => "Bermuda","BT" => "Bhutan","BO" => "Bolivia","BL" => "Bonaire","BA" => "Bosnia & Herzegovina","BW" => "Botswana","BR" => "Brazil","BC" => "British Indian Ocean Ter","BN" => "Brunei","BG" => "Bulgaria","BF" => "Burkina Faso","BI" => "Burundi","KH" => "Cambodia","CM" => "Cameroon","CA" => "Canada","IC" => "Canary Islands","CV" => "Cape Verde","KY" => "Cayman Islands","CF" => "Central African Republic","TD" => "Chad","CD" => "Channel Islands","CL" => "Chile","CN" => "China","CI" => "Christmas Island","CS" => "Cocos Island","CO" => "Columbia","CC" => "Comoros","CG" => "Congo","CK" => "Cook Islands","CR" => "Costa Rica","CT" => "Cote D'Ivoire","HR" => "Croatia","CU" => "Cuba","CB" => "Curacao","CY" => "Cyprus","CZ" => "Czech Republic","DK" => "Denmark","DJ" => "Djibouti","DM" => "Dominica","DO" => "Dominican Republic","TM" => "East Timor","EC" => "Ecuador","EG" => "Egypt","SV" => "El Salvador","GQ" => "Equatorial Guinea","ER" => "Eritrea","EE" => "Estonia","ET" => "Ethiopia","FA" => "Falkland Islands","FO" => "Faroe Islands","FJ" => "Fiji","FI" => "Finland","FR" => "France","GF" => "French Guiana","PF" => "French Polynesia","FS" => "French Southern Ter","GA" => "Gabon","GM" => "Gambia","GE" => "Georgia","DE" => "Germany","GH" => "Ghana","GI" => "Gibraltar","GB" => "Great Britain","GR" => "Greece","GL" => "Greenland","GD" => "Grenada","GP" => "Guadeloupe","GU" => "Guam","GT" => "Guatemala","GN" => "Guinea","GY" => "Guyana","HT" => "Haiti","HW" => "Hawaii","HN" => "Honduras","HK" => "Hong Kong","HU" => "Hungary","IS" => "Iceland","IN" => "India","ID" => "Indonesia","IA" => "Iran","IQ" => "Iraq","IR" => "Ireland","IM" => "Isle of Man","IL" => "Israel","IT" => "Italy","JM" => "Jamaica","JP" => "Japan","JO" => "Jordan","KZ" => "Kazakhstan","KE" => "Kenya","KI" => "Kiribati","NK" => "Korea North","KS" => "Korea South","KW" => "Kuwait","KG" => "Kyrgyzstan","LA" => "Laos","LV" => "Latvia","LB" => "Lebanon","LS" => "Lesotho","LR" => "Liberia","LY" => "Libya","LI" => "Liechtenstein","LT" => "Lithuania","LU" => "Luxembourg","MO" => "Macau","MK" => "Macedonia","MG" => "Madagascar","MY" => "Malaysia","MW" => "Malawi","MV" => "Maldives","ML" => "Mali","MT" => "Malta","MH" => "Marshall Islands","MQ" => "Martinique","MR" => "Mauritania","MU" => "Mauritius","ME" => "Mayotte","MX" => "Mexico","MI" => "Midway Islands","MD" => "Moldova","MC" => "Monaco","MN" => "Mongolia","MS" => "Montserrat","MA" => "Morocco","MZ" => "Mozambique","MM" => "Myanmar","NA" => "Nambia","NU" => "Nauru","NP" => "Nepal","AN" => "Netherland Antilles","NL" => "Netherlands","NV" => "Nevis","NC" => "New Caledonia","NZ" => "New Zealand","NI" => "Nicaragua","NE" => "Niger","NG" => "Nigeria","NW" => "Niue","NF" => "Norfolk Island","NO" => "Norway","OM" => "Oman","PK" => "Pakistan","PW" => "Palau Island","PS" => "Palestine","PA" => "Panama","PG" => "Papua New Guinea","PY" => "Paraguay","PE" => "Peru","PH" => "Philippines","PO" => "Pitcairn Island","PL" => "Poland","PT" => "Portugal","PR" => "Puerto Rico","QA" => "Qatar","RE" => "Reunion","RO" => "Romania","RU" => "Russia","RW" => "Rwanda","NT" => "St Barthelemy","EU" => "St Eustatius","HE" => "St Helena","KN" => "St Kitts-Nevis","LC" => "St Lucia","MB" => "St Maarten","PM" => "St Pierre & Miquelon","VC" => "St Vincent & Grenadines","SP" => "Saipan","SO" => "Samoa","AS" => "Samoa American","SM" => "San Marino","ST" => "Sao Tome & Principe","SA" => "Saudi Arabia","SN" => "Senegal","SC" => "Seychelles","SS" => "Serbia & Montenegro","SL" => "Sierra Leone","SG" => "Singapore","SK" => "Slovakia","SI" => "Slovenia","SB" => "Solomon Islands","OI" => "Somalia","ZA" => "South Africa","ES" => "Spain","LK" => "Sri Lanka","SD" => "Sudan","SR" => "Suriname","SZ" => "Swaziland","SE" => "Sweden","CH" => "Switzerland","SY" => "Syria","TA" => "Tahiti","TW" => "Taiwan","TJ" => "Tajikistan","TZ" => "Tanzania","TH" => "Thailand","TG" => "Togo","TK" => "Tokelau","TO" => "Tonga","TT" => "Trinidad & Tobago","TN" => "Tunisia","TR" => "Turkey","TU" => "Turkmenistan","TC" => "Turks & Caicos Is","TV" => "Tuvalu","UG" => "Uganda","UA" => "Ukraine","AE" => "United Arab Emirates","GB" => "United Kingdom","US" => "United States of America","UY" => "Uruguay","UZ" => "Uzbekistan","VU" => "Vanuatu","VS" => "Vatican City State","VE" => "Venezuela","VN" => "Vietnam","VB" => "Virgin Islands (Brit)","VA" => "Virgin Islands (USA)","WK" => "Wake Island","WF" => "Wallis & Futana Is","YE" => "Yemen","ZR" => "Zaire","ZM" => "Zambia","ZW" => "Zimbabwe","ZZ" => "unknown" }
  def countryNamesHash() @@COUNTRYNAMES end
  def skillNames() @@SKILLNAMES end
  def canPayNames() @@CANPAYNAMES end
  def statusNames() @@STATUSNAMES end
  def sexNames() @@SEXNAMES end
  def categoryNames() @@CATEGORYNAMES end
  def diseaseNames() @@DISEASECATEGORIES end
  def supplyStatusNames() @@SUPPLYSTATUSCATEGORIES end

  def printUnknownLong() "unknown" end
  def printUnknownShort() "?" end

  def years() @@YEARS end
  def months() @@MONTHS end
end
#    <%= htmlColumn('Name') %>
#    <td NOWRAP id="blackline"><strong><%= pager.htmlAnnotate(@controller, 'Gender') %></strong></td>
#    <td NOWRAP id="blackline"><strong><%= pager.htmlAnnotate(@controller, 'Age') %></strong></td>
#    <td NOWRAP id="blackline"><strong><%= pager.htmlAnnotate(@controller, 'Start') %></strong></td>
#    <td NOWRAP id="blackline"><strong><%= pager.htmlAnnotate(@controller, 'End') %></strong></td>
#    <td NOWRAP id="blackline"><strong><%= pager.htmlAnnotate(@controller, 'Dest') %></strong></td>
#    <td NOWRAP id="blackline"><strong><%= pager.htmlAnnotate(@controller, 'Origin') %></strong></td>
#    <td NOWRAP id="blackline"><strong><%= pager.htmlAnnotate(@controller, 'Skill') %></strong></td>
#    <td NOWRAP id="blackline"><strong><%= pager.htmlAnnotate(@controller, 'Skill Description') %></strong></td>
