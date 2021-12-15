module Constructor
  def new(*)
    super.tap { |instance| instance.instance_variable_set(:@version, -1) }
  end
end
