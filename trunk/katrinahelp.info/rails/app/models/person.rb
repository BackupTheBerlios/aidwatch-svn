class Person < ActiveRecord::Base
  def valid?()
    if last_name
      last_name.gsub(/\s/,'').size > 4
    else
      false
    end
  end
end
