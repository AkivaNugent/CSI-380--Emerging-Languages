require "./combatant"

class Wizard
  include Combatant

  def initialize
    @health = 50
    @damage = 16
  end
end
