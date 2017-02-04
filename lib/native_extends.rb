class String
  # legacy censor
  def censor
    gsub(/\bass\b|asshole|jackass|retard/i, '[rearward-facing primate orifice]')
        .gsub(/fu?ck|\bcunt\b|shit|douche|bitch|nigger|(d|pr)ick/i, '[delightful bamboo-eating panda]')
        .gsub(/(f|ph)aggot|\bfag\b|idiot|mofo/i, '[the person I love the most]')
        .gsub(/dumb|asinine|stupid/i, '[inspiring]')
  end

  def to_bool
    # force it to return nil unless exact match
    case self
      when 'true'
        true
      when 'false'
        false
      else
        nil
    end
  end
end