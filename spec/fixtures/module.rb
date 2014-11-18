# complexity:1
module HasToppings

  def random_topping
    if rand(10) < 5
      return "meatball"
    else
      return "pepperoni"
    end
  end

end