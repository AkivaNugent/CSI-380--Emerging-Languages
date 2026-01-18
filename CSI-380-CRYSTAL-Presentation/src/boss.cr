require "./combatant"

class Boss
  include Combatant

  def initialize
    @health = 300
    @damage = 15
  end
  
end
