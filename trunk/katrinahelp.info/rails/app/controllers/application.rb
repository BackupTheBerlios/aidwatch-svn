# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base

  def paginate_from_sql(model, sql, total, per_page)
    @person_pages = Paginator.new self, total, per_page, @params['page']
    if @person_pages
      @people = model.find_by_sql(sql + "ORDER BY last_name LIMIT #{per_page} " +
                              "OFFSET #{@person_pages.current.to_sql[1]}")
    else
      @people = nil
    end
  end

  def dbesc(str)
    str = str.clone
    str.gsub!(/\\/,'\\\\\\')
    str.gsub!(/[']/,'\\\\\'')
    "'#{str}'"
  end

  def loadavg
    cmdname = '/usr/bin/uptime'
    upt = nil
    `#{cmdname}`.gsub(/load average:\s+([\d.]*)/) { |mat| upt = $1 }
    upt.to_f
  end

  def isOkToSearch
    #loadavg < 0.75
    loadavg < 1.2
  end

  def whereclause(searchterm)
      "MATCH(searchstuff) AGAINST(#{dbesc(searchterm)})"
  end

  def sqlstmt(searchterm)
      "SELECT * FROM people WHERE #{whereclause(searchterm)}";
  end

end
