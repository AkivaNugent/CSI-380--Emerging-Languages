module Combatant
    property health : Float64
    property damage : Float64
    property defending : Bool = true
  
    def attack(enemy : Combatant)
      enemy.take_damage(@damage)
    end
  
    def take_damage(damage : Float64)
      if defending
        damage = damage / 2
        @defending = false
      end

      @health -= damage
      if @health < 0
        @health = 0
      end
    end

    def heal
      @health += 20
    end

    def is_alive
      @health > 0
    end
  end
  