module ApplicationHelper
  def nameify(user)
    return user.display_name unless !user.display_name || user.display_name.strip.empty?
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

  def markdown(txt, render_opts={})
    options     = {
        space_after_headers: true,
        fenced_code_blocks:  true,
        autolink:            true,
        superscript:         true,
        underline:           true,
        no_intra_emphasis:   true,
        tables:              true
    }
    render_opts = {
        filter_html:     true,
        hard_wrap:       true,
        with_toc_data:   true,
        link_attributes: { rel: 'nofollow', target: '_blank' }
    }.merge render_opts
    renderer    = Redcarpet::Render::HTML.new render_opts
    markdown    = Redcarpet::Markdown.new renderer, options

    markdown.render(txt).html_safe
  end

  def obs(int)
    int = int.to_i
    raise TypeError unless int > 0

    x, y = (int >> 16) & 65535, int & 65535
    fn   = ->(val) { (32767 * (((1366 * val + 15089) & 714025) / 714025.0)).to_i }
    3.times { x, y = y, x ^ fn.call(y) }
    (y << 16) + x
  end

  def pager(location, collection, opt = {})
    if location == :top
      render 'layouts/pager', info: true, collection: collection, name: opt[:name] || 'entry'
    else
      render 'layouts/pager', info: false, collection: collection if collection.total_pages > 1
    end
  end
end