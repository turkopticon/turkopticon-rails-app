module ReviewsHelper

  def semantic_params(params)
    # params[:comments] = true if params[:user].present?
    params.delete_if { |_, v| v == 'false' }

    sem = params.sort.map do |v|
      case v[0]
        when :user, 'user' then
          "by #{v[1]}"
        when :comments, 'comments' then
          :comments
        when :flags, 'flags' then
          :flags
        else
          nil
      end
    end

    sem.insert(1, :and) if params.key?(:flags) && params.key?(:comments)
    sem.insert(0, :with) if params.key?(:flags) || params.key?(:comments)
    sem.join ' '
  end

  def pay_rate(pay, time, opt = {})
    opt = { unit: :hr, split: false }.merge(opt)

    unless time && time > 0
      return opt[:split] ? ['--', opt[:unit]] : nil
    end

    base = pay/time
    exp  = case opt[:unit]
             when :hr, :h, :hour then
               2
             when :min, :m, :minute then
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
    if sec > 86400 && approx
      '%.2f days' % (sec/86400.0)
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