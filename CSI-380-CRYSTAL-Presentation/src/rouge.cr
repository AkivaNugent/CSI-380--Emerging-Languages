require "./combatant"

class Rouge
  include Combatant

  def initialize
    @health = 100
    @damage = 10
  end
end