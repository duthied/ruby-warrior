
require 'byebug'

class Player

  def play_turn(warrior)
    @health ||= warrior.health
    @hit_the_wall ||= false
    
    puts "@hit_the_wall #{@hit_the_wall}"
    @hit_the_wall ? feel_forward(warrior) : feel_backward(warrior)
    
    @health = warrior.health
  end
  
  def feel_backward(warrior)
    case
    when warrior.feel(:backward).empty?
      warrior.walk!(:backward)
    
    when warrior.feel(:backward).captive?
      warrior.rescue!(:backward)
      
    when warrior.feel(:backward).wall? && wounded?(warrior)
      puts "warrior.feel(:backward).wall? #{warrior.feel(:backward).wall?} and wounded?(warrior) #{wounded?(warrior)}"
      warrior.rest!
      @hit_the_wall = true
      puts "@hit_the_wall #{@hit_the_wall}"

    when warrior.feel(:backward).wall? 
      puts "warrior.feel(:backward).wall? #{warrior.feel(:backward).wall?}"
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
  
end
  