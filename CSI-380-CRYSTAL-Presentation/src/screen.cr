class Screen
    def initialize
      @wizard_health = 50.0
      @rouge_health = 100.0
      @boss_health = 300.0
      @knight_health = 120.0
      @combat_msg = ""
      @boss_msg = ""
      
      @wizard_pos = [7, 5]
      @rouge_pos = [10, 5]
      @boss_pos = [10, 35]
      @knight_pos = [13, 5]
      @message_pos = [15, 1]
      @boss_msg_pos = [3, 2]
    end
  
    def setup_screen
      clear_screen
      
      puts ""
      puts " _____________________________________________ "
      puts "| #{@boss_msg.ljust(43)} |"  
      puts "|_____________________________________________|"
      puts ""
      puts "    WIZARD 🧙"
      puts "    #{@wizard_health.to_i}/50"
      puts ""                         
      puts "    ROUGE 🗡️                         BOSS 👿"
      puts "    #{@rouge_health.to_i}/100\t\t\t\t\t\t\t#{@boss_health.to_i}/300"
      puts "" 
      puts "    KNIGHT 🤖"
      puts "    #{@knight_health.to_i}/120"
      puts "|_____________________________________________|"
      puts @combat_msg
    end
    
    # UPDATE HEALTH VALUES -------------------------------------------------------
    def update_health(character, health)
      case character
      when "wizard"
        @wizard_health = health
      when "rouge"
        @rouge_health = health
      when "boss"
        @boss_health = health
      when "knight"
        @knight_health = health
      end
      setup_screen
    end
    
    # UPDATE MESSAGES -------------------------------------------------------------
    def update_message(message)
      @combat_msg = message
      setup_screen
    end
    
    def print_boss_message(message)
      @boss_msg = message
      setup_screen
    end
    
    def clear_boss_message
      @boss_msg = ""
      setup_screen
    end

    # PRINT MENUING --------------------------------------------------------------
    
    def print_menu(character)
      update_message("#{character}'s Turn ::: [1] Attack [2] Defend [3] Heal")
    end
    
    def print_preparing
      update_message("Preparing To Attack...")
    end

    # PRINT WIN/LOSE -------------------------------------------------------------
    
    def print_win
      clear_screen
      puts "Congratulations! You Win!"
    end
    
    def print_lose
      clear_screen
      puts "Game Over! The boss has defeated your party!"
    end
    
    # SCREEN UTILITIES -----------------------------------------------------------

    def move_cursor(row, col)
      print "\e[#{row};#{col}H"
    end
  
    def move_cursor_back
      move_cursor(16, 1)
    end
    
    def clear_screen
      print "\33c\e[3J"
    end

    def clear_input
        move_cursor_back
        print "".ljust(43)
    end
end
