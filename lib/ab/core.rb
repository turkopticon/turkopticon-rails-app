module AB::Core
  def ab(name, variants)
    session[name] = variants.keys.sample if session[name].nil?

    if ABTest.find_by(name: name).nil?
      create_test name, variants
    end

    variants[session[name].to_sym]
  end

  def ab_impression(name, variant)
    ABTest.includes(:variants)
        .where(name: name).take.variants
        .where(name: variant).increment! :sample
  end

  def ab_conversion(name, variant, user_id)
    ABTest.includes(:variants)
        .where(name: name).take.variants
        .where(name: variant).increment! user_id
  end

  def ab_reset(name)
    session[name] = nil
  end

  protected

  def create_test(name, variants)
    test = ABTest.create name: name
    variants.each { |k, _| ABTest::Variant.create name: k, abtest: test }
  end
end
