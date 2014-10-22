class Foo

  def penultimate_method
    ultimate_method
  end

  def initial_method
    penultimate_method
    penultimate_method
    penultimate_method
  end

  def external_call
    Bar.new.say_hello
  end

  private

  def ultimate_method
    self.to_s
  end
end
