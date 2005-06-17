class LocationController < ApplicationController

  model :location, :person
  layout 'wavedb'
  before_filter :login_required

	def index()
    render_text "This is the index for location"
	end
  def makeFullcode(goodlocs, loc)
    parts = [ ]
    loctofind = loc.id
    while loctofind != 0
      loc = goodlocs[loctofind]
      parts.unshift(loc.loccode)
      loctofind = loc.parent
    end
    parts.join('-')
  end
  def testStructure()
    msgs = [ ]
    fullcodes = { }
    parloc = { }
    locs = Location.find_all
    goodlocs = { }
    locs.each { |loc| goodlocs[loc.id] = loc }
    locs.each { |loc|
      fullcodes[loc.fullcode] = (fullcodes[loc.fullcode] || 0) + 1
      parloc["#{loc.parent}-#{loc.loccode}"] = (parloc["#{loc.parent}-#{loc.loccode}"] || 0) + 1
      genfullcode = makeFullcode(goodlocs, loc)
      msgs << "Unmatching code for Location #{loc}" unless loc.fullcode == genfullcode
    }
    res = fullcodes.values.inject(1) { |a,i| a*i }
    if res == 1
      msgs << "Fullcodes unique"
    else
      msgs << "Fullcodes not unique"
    end
    res = parloc.values.inject(1) { |a,i| a*i }
    if res == 1
      msgs << "ParLoc unique"
    else
      msgs << "ParLoc not unique"
      parloc.each { |k,v|
        msgs << "#{k} came up #{v}" if v != 1
      }
    end
    @msg = msgs.join('<br>')
  end

#  def destroy
#    loc = Location.find(alGrabID())
#    togo = (loc.hasParent?) ? loc.parent.to_s : 1.to_s
#    if loc
#      loc.destroy
#    end
#    redirect_to :action => 'show', :id => togo
#  end
#
#  def update()
#		id = alGrabID()
#		unless id
#			render_action 'show' 
#			return
#		end
#    @loc = Location.find(id)
#    @loc.attributes = alGrabParams()
#    if @loc.save
#      flash['notice'] = 'Location was successfully updated.'
#      redirect_to :action => 'show', :id => id
#    else
#      redirect_to :action => 'edit', :id => id
#    end
#  end

	def show()
    id = alGrabID() || 1
    @loc = Location.find(id)
    @session['sessloc'] = @loc if @loc
	end

#  def new
#    lastParent = @session['sessloc']
#    @loc = Location.new
#    if lastParent
#      @loc.parent = lastParent.id
#    end
#  end

#  def create
#    id = alGrabID()
#    @loc = Location.new(id)
#    @loc.attributes = alGrabParams()
#    if @loc.save
#      flash['notice'] = 'Location was successfully created.'
#      redirect_to :action => 'show', :id => id
#    else
#      render_action 'new'
#    end
#  end

# eval str / #{ }   evaluates the contents of str in the program domain
# str       refers to our variable called str, in the program domain
# "while"     returns a String instance

#  eval("eval('fucnrdthsucngtgdjbprgmn!')")
  def doLocSet()
    @lsmsg = "i am in doLocset with classnames #{@session['locset']['locclass']}"
    changeto = @params['changeto']
    confirm = @params['lsc']

    locparm = @session['locset']
    locparm['locid'] = changeto if changeto
    @curloc = Location.find(locparm['locid']) || Location.find(1)

    @locchildren = @curloc.children

    if confirm
      cbcon = locparm['cbloccon']
      cbmem = locparm['cblocmem']
      objid = locparm['locobject_id']
      fn = locparm['locfield']
      cn = locparm['locclass']

      @session['choseloc'] = @curloc
      @session['choselocfield'] = fn

      obj = nil
      cmdstr = "obj = #{cn}.find(#{objid.to_i})"
      begin
        eval cmdstr
      rescue
      end
      @session['locset'] = nil
      @session['choseloc'] = nil
      @session['choselocfield'] = nil
      if obj
        @lsmsg = "obj.#{fn} = @curloc.fullcode worked with #{cmdstr}"
        eval "obj.#{fn} = @curloc.fullcode"
        obj.save
      end
      redirect_to :controller => cbcon, :action => cbmem, :id => objid
    else
      render 'location/goodLocSet'
    end
  end

  def verifyParm(locparm)
    return false unless locparm.is_a?(Hash)
#    return false unless ['person'].include?(locparm['cbloccon'])
#    return false unless ['Person'].include?(locparm['locclass'])
    return false unless ['lostloc','stayingloc','foundloc','targetloc','curloc','loc'].include?(locparm['locfield'])
    return false unless ['list', 'show', 'edit','update','adjustStatusOrLocation'].include?(locparm['cblocmem'])
    return true
  end

  def goodLocSet()
    cn = @session['locclass'] || alGrabParams()['locclass']
    @curloc = Location.find(1)
    locparm = { }
    ['cbloccon','locclass','locfield','locobject_id','cblocmem'].each { |p|
      locparm[p] = @params[p].to_s || ''
    }
#    @lsmsg = "it is #{locparm.inspect}"
    @lsmsg = "hangin out in goodlocset with #{locparm['locclass']}"
    if verifyParm(locparm)
      @session['locset'] = locparm
      locparm['locid'] = 1
      redirect_to :action => 'doLocSet'
    else
      redirect_to :action => 'index'
    end
  end

end
