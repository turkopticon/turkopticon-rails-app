module AB::Model
  def increment!(target)
    case target
      when :sample # on impression
        data[:sample] += 1
      when Integer # on conversion
        data[:distribution][target.to_s] ||= 0
        data[:distribution][target.to_s] += 1
        data[:conversions][:total]       += 1
        data[:conversions][:unique]      = data[:distribution].keys.length
      else
        raise ArgumentError
    end

    save!
  end

end

# {
#   sample: N, ( total impressions / participants )
#   conversions: {
#     total: N,
#     unique: N
#   },
#   distribution: {
#     *userId: N,
#     *userId: N,
#     ...
#   }
#
# }
