module AB::Core
  def ab(name, variants)
    session[name] = variants.keys.sample if session[name].nil?

    if AB::Test.find_by(name: name).nil?
      create_test name, variants
    end

    variants[session[name].to_sym]
  end

  def ab_impression(name, variant)
    # AB::Variant.where(name: variant).joins(:test).where(ab_tests: {name: name}).take.increment! :sample
    AB::Variant.isolate(name, variant).increment! :sample
  end

  def ab_conversion(name, variant, user_id)
    AB::Variant.isolate(name, variant).increment! user_id
  end

  def ab_reset(name)
    session[name] = nil
  end

  protected

  def create_test(name, variants)
    test = AB::Test.create name: name
    variants.each { |k, _| AB::Variant.create name: k, test: test }
  end
end
