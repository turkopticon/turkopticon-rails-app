module ReviewsHelper

  def title_from_params(params, target_user)
    title = target_user.nil? ? 'Recent Reviews' : 'Reviews'

    if target_user
      user  = "by #{nameify target_user}"
      scope = (params[:scope] || []).uniq.select { |s| %w(comments flags).include? s }
      scope = scope.empty? ? nil : 'with ' << scope.join(' or ')
      title = [title, scope, user].join ' '
    end

    title
  end

  def pay_rate(pay, time, opt = {})
    opt = { unit: :hr, split: false }.merge(opt)

    unless time && time > 0
      return opt[:split] ? ['--', opt[:unit]] : nil
    end

    base = pay/time
    exp  = case opt[:unit]
             when :hr
               2
             when :min
               1
             else
               0
           end
    str  = '$%.2f' % (base * 60 ** exp)
    return str << "/#{opt[:unit]}" unless opt[:split]
    [str, opt[:unit]]
  end

  def htime(sec, opt = {})
    sec = sec.to_i
    return nil unless sec && sec > 0
    if opt[:approx]
      hours = sec.to_f / 60**2
      '%s%s %s' % htime_approx(hours, opt)
    else
      units = %w(d h m s)
      [sec/86400, sec%86400/3600, sec/60%60, sec%60]
          .map.with_index { |v, i| v.to_s << units[i] }
          .select { |v| v =~ /[1-9]/ }
          .join
    end
  end

  def pct(vals)
    x, n = vals
    n > 0 ? '%.f%%' % (100*x/n.to_f) : '--'
  end

  def tag_class(data)
    name, value = data
    case
      when name == 'rejected' && value then
        'critical'
      when name == 'recommend' && value == 'yes' then
        'positive'
      else
        'negative'
    end
  end

  def tag_label(tag)
    if tag[0] == 'recommend'
      tag[1] == 'no' ? 'not recommended' : tag[0] << 'ed'
    else
      tag[0]
    end
  end

  private

  def htime_approx(hours, opt = {})
    pre    = opt[:slim] ? '<' : 'less than '
    unit   = :hour
    abbrev = ->(u, o) {return u unless o[:slim]; map = { hour: :hr, minute: :min, day: :day }; map[u]}

    if hours < 0.5
      span = 30
      unit = :minute
    elsif hours < 1
      span = 1
    elsif hours < 24
      span = [1, hours.round].max
      pre  = hours % 1 > 0 && (opt[:slim] ? '~' : 'about ') || ''
    else
      span = hours / 24
      pre  = ''
      unit = :day
    end

    [pre,
     (span % 1 > 0 ? '%.2f' : '%i') % span,
     (abbrev.call unit, opt).to_s.pluralize(span)]
  end
end