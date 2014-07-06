def grow_flowers(seed, water, earth)
  def water_earth(water, earth)
    earth.insert(water)
  end
  
  earth.insert.seed
  50.times(water_earth(water, earth))
end