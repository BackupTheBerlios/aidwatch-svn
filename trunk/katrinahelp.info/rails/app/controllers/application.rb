# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base

  def paginate_from_sql_pets(model, sql, total, per_page)
    @pet_pages = Paginator.new self, total, per_page, @params['page']
    if @pet_pages
      @pets = model.find_by_sql(sql + "ORDER BY petname LIMIT #{per_page} " +
                              "OFFSET #{@pet_pages.current.to_sql[1]}")
    else
      @pets = nil
    end
  end

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
    return 0.5
    cmdname = '/usr/bin/uptime'
    upt = nil
    `#{cmdname}`.gsub(/load average:\s+([\d.]*)/) { |mat| upt = $1 }
    upt.to_f
  end

  def isOkToSearch
    #loadavg < 0.75
    #loadavg < 1.2
    true
  end

  def whereclause(searchterm)
      "MATCH(searchstuff) AGAINST(#{dbesc(searchterm)})"
  end

  def sqlstmt(searchterm)
      "SELECT * FROM people WHERE #{whereclause(searchterm)}";
  end

  def sqlstmtpets(searchterm)
      "SELECT * FROM pets WHERE #{whereclause(searchterm)}";
  end

end
