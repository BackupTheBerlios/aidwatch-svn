module WavedbHelper
  def render_errors(obj)
	  return "" unless obj
	  return "" unless @request.post?
		tag = String.new

		unless obj.valid?
			tag << %{<ul class="objerrors">}			
			obj.errors.each_full { |message| tag << %{<li>#{message}</li>} }
			tag << %{</ul>}
		end
    tag
	end

  def setPrivBox(u,cname,fn)
    allowed,oldset = case fn
      when 'readp'
        [@user.canSetRead?(cname), u.isReader?(cname)]
      when 'writep'
        [@user.canSetWrite?(cname), u.isWriter?(cname)]
      when 'managep'
        [@user.canSetManage?(cname), u.isManager?(cname)]
      when 'adminp'
        [@user.canSetAdmin?(cname), u.isAdmin?(cname)]
      else
        fail "Fieldname disallowed in setPrivBox: #{fn}"
        [0,0]
    end
    if allowed
      "<input name='privForm[#{u.id}][#{fn}]' type='checkbox' value='checked' #{ oldset ? 'checked' : ''} >"
    else
      oldset ? "X" : "&nbsp;"
    end
  end

end

