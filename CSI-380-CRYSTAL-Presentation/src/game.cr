require "./rouge"
require "./knight"
require "./wizard"
require "./boss"
require "./screen"

WIZARD_COOLDOWN = 10
ROUGE_COOLDOWN = 6
KNIGHT_COOLDOWN = 15
BOSS_COOLDOWN = 10

class Game
  def initialize
    @rouge = Rouge.new
    @wizard = Wizard.new
    @knight = Knight.new
    @boss = Boss.new
    @potions = 5
    @gamestate = Screen.new

    @rouge_busy = false
    @wizard_busy = false
    @knight_busy = false

    @action_channel = Channel(Symbol).new
  end

  # MACROS --------------------------------------
  macro cooldown(time)
    sleep {{time}}.seconds
  end

  # BOSS ACTIONS --------------------------------

  def bosses_turn()
    spawn do
      attack_options = [@rouge, @wizard, @knight]
      loop do
        break if attack_options.empty? 
        break unless @boss.is_alive
        
        cooldown(BOSS_COOLDOWN)

        target_index = rand(0..attack_options.size-1)
        target = attack_options[target_index]

        @gamestate.print_boss_message("Boss attacked #{target.class}!")
        
        attack(@boss, target)
        update_character_health(target)

        cooldown(1)
        @gamestate.clear_boss_message

        if target.health <= 0
          attack_options.delete(target)
        end
      end
    end
  end

  # CHARACTER COOLDOWNS -------------------------

  def character_cooldowns
    spawn do
      loop do
        break unless @rouge.is_alive

        unless @rouge_busy
          cooldown(ROUGE_COOLDOWN)

          @rouge_busy = true
          @action_channel.send(:rouge)
        else
          cooldown(0.1)
        end
      end
    end

    spawn do
      loop do
        break unless @wizard.is_alive

        unless @wizard_busy
          cooldown(WIZARD_COOLDOWN)

          @wizard_busy = true
          @action_channel.send(:wizard)
        else
          cooldown(0.1)
        end
      end
    end

    spawn do
      loop do
        break unless @knight.is_alive

        unless @knight_busy
          cooldown(KNIGHT_COOLDOWN)

          @knight_busy = true
          @action_channel.send(:knight)
        else
          cooldown(0.1)
        end
      end
    end
  end

  # PARTY ACTIONS -------------------------------

  def defend(character)
    character.defending = true
    @gamestate.update_message("#{character.class} is defending")
  end

  def heal(character)
    if @potions > 0
      character.heal
      @potions -= 1
      @gamestate.update_message("#{character.class} healed! #{@potions} potions left")
      update_character_health(character)
    else
      @gamestate.update_message("No potions left")
    end
  end

  def attack(character, target)
    target.take_damage(character.damage)
    update_character_health(target)
  end
  
  def update_character_health(character)
    case character
    when @wizard
      @gamestate.update_health("wizard", character.health)
    when @rouge
      @gamestate.update_health("rouge", character.health)
    when @boss
      @gamestate.update_health("boss", character.health)
    when @knight
      @gamestate.update_health("knight", character.health)
    end
  end

  # MENUING -------------------------------------

  def menu(character)
    case character
    when @rouge
      @gamestate.print_menu("rouge")
    when @wizard
      @gamestate.print_menu("Wizard")
    when @knight
      @gamestate.print_menu("Knight")
    end

    action = gets.to_s.strip
    case action
    when "1"
      attack(character, @boss)
      @gamestate.update_message("#{character.class} attacked the Boss!")
    when "2"
      defend(character)
    when "3"
      heal(character)
    else
      @gamestate.update_message("Invalid Input, Defaulting to Attack")
      attack(character, @boss)
      @gamestate.update_message("#{character.class} attacked the Boss!")
    end

    case character
    when @rouge
      @rouge_busy = false
    when @wizard
      @wizard_busy = false
    when @knight
      @knight_busy = false
    end
  end

  def awaiting_actions
    action = @action_channel.receive

    case action
    when :rouge
      menu(@rouge) if @rouge.is_alive
    when :wizard
      menu(@wizard) if @wizard.is_alive
    when :knight
      menu(@knight) if @knight.is_alive
    end

    @gamestate.clear_input
  end

  # BATTLE LOGIC --------------------------------
  
  def battle
    @gamestate.setup_screen
    @gamestate.print_preparing
  
    bosses_turn()
    character_cooldowns()
    
    while @boss.is_alive && 
          (
          @rouge.is_alive || 
          @wizard.is_alive || 
          @knight.is_alive
          )

      awaiting_actions()
      cooldown(0.1)
    end

    if @boss.is_alive
      @gamestate.print_lose
    else
      @gamestate.print_win
    end
  end
end