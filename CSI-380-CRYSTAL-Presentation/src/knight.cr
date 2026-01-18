require "./combatant"

class Knight
  include Combatant

  def initialize
    @health = 120
    @damage = 8
  end
end
