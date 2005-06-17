module WaveDBUtils
  @@VALIDCONTROLLERS = ['disease','phonenum','location','person','volunteer','supply','wavedb']
  def validControllers() @@VALIDCONTROLLERS end

  module PagedResultsControllerHelper
    def sessionKey() controller_name + 'sort' end

    def pagerLoadResults(obj) getPager().loadResults(obj) end
    def getPager()
      @pager || (@session && @session[sessionKey])
    end
    def setPager(obj)
      fail "Cannot use pager #{obj}" unless obj.is_a?(PagedResultsPortal)
      @session[sessionKey] = obj
      @pager = obj
    end

    def refreshPage
      @pager = getPager
      render_action 'list'
    end

    def choseItem()
      objsort = getPager
      p = nil
      if objsort
        p = alGrabParams()
        fn = p['fieldname']
        if fn
          objsort.choseItem(fn)
        end
      end
      @pager = getPager
      render_action ((p && p['oldaction']) || 'list')
    end

    def doFirstPage
      getPager.clickFirst
      refreshPage
    end

    def doLastPage
      getPager.clickLast
      refreshPage
    end

    def doPrevPage
      getPager.clickPrev
      refreshPage
    end

    def doNextPage
      getPager.clickNext
      refreshPage
    end
  end

  class PagedResultsPortal
    attr_reader :numperpage
    def initialize(objary, sortorder, numperpage=50)
      @objary = objary.clone
      @sortorder = sortorder
      @numperpage = numperpage
      @pagenum = 0
      resort
    end
    def loadResults(objary)
      objary = [ ] unless objary
      @objary = objary.clone
      if curpagenum > lastPage
        curpagenum = 0
      end
      resort
    end
    def each() curpage.each() { |i| yield i } end
    def size() @objary.size() end
    def resort() @objary.sort!() { |a,b| @sortorder.sortout(a,b) } end
    def allColumnsOriginalOrder() @sortorder.allColumnsOriginalOrder end
    def sortout(a,b) @sortorder.sortout(a,b) end
    def findStr(str) @sortorder.findStr(str) end
    def parstr(str) @sortorder.parstr(str) end
    def major() @sortorder.major() end
    def htmlAnnotate(con, str) @sortorder.htmlAnnotate(con, str) end
    def annotate(str) @sortorder.annotate(str) end
    def choseItem(str)
      @sortorder.choseItem(str)
      if @sortorder.major.symbol == 'relevance' &&  @sortorder.major.parity < 0
        @sortorder.major.flip
      end
      resort
    end
    def refreshObj(id)
      indnum, obj = nil, nil
      @objary.each_with_index { |obj, i|
        if obj.id == id
          begin
            obj = obj.class.find(id)
          rescue
            obj = nil
          end
          @objary[i] = obj
        end
      }
      @objary.compact!
    end
    def objcount() @objary.size end
    def pagecount() (objcount + numperpage - 1) / numperpage end
    def firstPage() 0 end
    def lastPage() firstPage + pagecount - 1 end
    def eachPage()
      pagecount.times { |i|
        yield i
      }
    end
    def curpagenum() @pagenum end
    def friendlyPagenum() curpagenum + 1 end
    def numshow() curpagenum==pagecount ? objcount%numperpage : numperpage end
    def curpage() @objary[curpagenum*numperpage, numshow] end
    def setpage(i) @pagenum = i % pagecount end
    def clickNext() @pagenum = (@pagenum + 1) % pagecount end
    def clickPrev() @pagenum = (@pagenum + pagecount - 1) % pagecount end
    def clickFirst() @pagenum = 0 end
    def clickLast() @pagenum = pagecount-1 end
  end
  # Fetches a date from the alGrabParams form parameters according to a passed-in string.
  # The data should be structured as a nested hash of y, m, d in the HRML form.
  def rCreateDate(subname)
    params = alGrabParams()[subname]
    if params
      begin
        y = params['y']
        m = params['m']
        d = params['d']
        return Time.local(y, m, d, 10, 10, 10)
      rescue
      end
    end
    return Time.new
  end

  # Returns the most appropriate basis for HTML form parameters.  This is usually the
  # subhash with the same name as the currently active controller, @params['controller']
  def alGrabParams()
    cstr = @params['controller']
    if cstr
      str = cstr
      return @params[str] if @params[str]
    end
    return @params
  end

  def alGrabID()
    return @params['id'] || alGrabParams()['id']
  end

  def entries(emailstr)
    return [ ] if emailstr == nil || emailstr =~ /^\s*$/
    emailstr.split(/[,;]/).sort.uniq
  end

  def isInList?(emailstr, addr)
    entries(emailstr).include?(addr)
  end

  def makeList(entries)
    entries ||= [ ]
    entries.sort.uniq.join(',')
  end

  def addToList(emailstr, newguy)
    makeList([entries(emailstr),newguy].flatten)
  end

  def removeFromList(emailstr, goneguy)
    e = entries(emailstr)
    e.delete(goneguy)
    makeList(e)
  end

  module_function :validControllers
end
