
class Player

  def play_turn(warrior)
    # @health ||= warrior.health
    # @position_initialized ||= false
    # @warrior ||= warrior
    
    # @position_initialized ? feel_forward(warrior) : feel_backward(warrior)
    feel_forward(warrior)
    # @health = warrior.health
  end
  
  def feel_backward(warrior)
    case
    when warrior.feel(:backward).empty?
      warrior.walk!(:backward)
    
    # when warrior.feel(:backward).captive?
    #   warrior.rescue!(:backward)
      
    # when warrior.feel(:backward).wall?
    #   @position_initialized = true
        
    end
  end
  
  def feel_forward(warrior)
    # byebug
    case
    # when warrior.feel.captive?
    #   warrior.rescue!
      
    when warrior.feel.enemy?
      warrior.attack!
      
    # when warrior.feel.empty? && wounded? && !under_attack?
    #   warrior.rest!
    
    when warrior.feel.empty?
      warrior.walk!
     
    end
  end
  
  def under_attack?
    @health > @warrior.health
  end
  
  def wounded?
    @warrior.health < 20
  end
  
end
  