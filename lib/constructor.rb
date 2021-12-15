module Constructor
  def new(*)
    super.tap { |instance| instance.instance_variable_set(:@version, -1) }
  end

  # https://eregon.me/blog/2021/02/13/correct-delegation-in-ruby-2-27-3.html
  ruby2_keywords :new if respond_to?(:ruby2_keywords, true)
end
