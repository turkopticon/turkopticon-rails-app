module ApplicationHelper
  def nameify(user)
    return user.display_name unless !user.display_name || user.display_name.empty?
    id, domain = user.email.split '@'
    id[0, [id.length/2, 1].max] << '...@' << domain[0, 1] << '...'
  end

  def user_class(user)
    case
      when user.admin? then
        content_tag(:span, '[A]', class: [:tag, :user, :admin])
      when user.moderator? then
        content_tag(:span, '[M]', class: [:tag, :user, :mod])
      else
        nil
    end
  end
end
