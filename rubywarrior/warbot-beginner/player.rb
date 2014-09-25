
require 'byebug'

class Player

  def play_turn(warrior)
    @health ||= warrior.health
    @hit_the_wall ||= false
    @action_taken = false

    if warrior.feel.wall?
      warrior.pivot!
      @action_taken = true
    end

    # display_status(warrior)
    @hit_the_wall ? feel_forward(warrior) : feel_backward(warrior) unless @action_taken

    @health = warrior.health
  end
  
  def feel_backward(warrior)
    case
    when warrior.feel(:backward).empty?
      warrior.walk!(:backward)
    
    when warrior.feel(:backward).captive?
      warrior.rescue!(:backward)
      
    when warrior.feel(:backward).wall? && wounded?(warrior)
      warrior.rest!
      @hit_the_wall = true

    when warrior.feel(:backward).wall? 
      @hit_the_wall = true
        
    end
  end
  
  def feel_forward(warrior)
    case

    when warrior.feel.captive?
      warrior.rescue!
      
    when warrior.feel.enemy?
      warrior.attack!
      
    when warrior.feel.empty? && wounded?(warrior) && !under_attack?(warrior)
      # warrior.rest!
      if warrior.feel(:backward).empty?
        @hit_the_wall = false
        warrior.walk!(:backward)
      else
        warrior.rest!
      end
      
    when warrior.feel.empty?
      warrior.walk!
     
    end
  end
  
  def under_attack?(warrior)
    @health > warrior.health
  end
  
  def wounded?(warrior)
    warrior.health < 20
  end

  def display_status(warrior)
    puts ''
    puts '================[ status ]================'
    puts "health: #{warrior.health}"
    puts "under attack?: #{under_attack?(warrior)}"
    puts '=========================================='
    puts ''
  end

  def log_this(message)
    puts "-------------------[ log ]--------------------------"
    puts " #{message}"
    puts "----------------------------------------------------"
  end
  
end
  