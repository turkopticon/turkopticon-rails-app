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

  def htime(sec, approx = true)
    sec = sec.to_i
    return nil unless sec && sec > 0
    if sec >= 86400 && approx
      est = sec/86400.0
      tmp = est > 1 ? '%.2f ' : '%i '
      (tmp % est) << 'day'.pluralize(est)
    else
      units = %w(d h m s)
      [sec/86400, sec%86400/3600, sec/60%60, sec%60]
          .map { |v| v.to_s.rjust(2, '0') }
          .map.with_index { |v, i| v << units[i] }
          .select { |v| v =~ /[1-9]/ }
          .join
    end
  end

  def tag_class(data)
    name, value = data
    case
      # when name == 'rejected' && value then
      #   'critical'
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
end