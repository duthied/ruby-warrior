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

    look_forward_and_react(warrior) unless @action_taken

    @health = warrior.health
  end

  def look_forward_and_react(warrior)
    area_info = assess_area(warrior.look)
    
    if area_info[:clear_shot]
      warrior.shoot!
    elsif area_info[:captive_visible] && area_info[:captive_range] == 0
      warrior.rescue!
    elsif area_info[:captive_visible] && area_info[:captive_range] > 0
      do_walk(warrior)
    else
      do_walk(warrior)
    end
    @action_taken = true
  end

  def assess_area(spaces)
    area_info = {}

    if spaces.any?(&:enemy?)
      area_info[:enemy_visible] = true
      area_info[:enemy_range] = spaces.index { |space| space.enemy? == true }
    end

    if spaces.any?(&:captive?)
      area_info[:captive_visible] = true
      area_info[:captive_range] = spaces.index { |space| space.captive? == true }
    end

    if area_info[:enemy_visible] && area_info[:captive_visible]
      area_info[:clear_shot] = true if area_info[:enemy_range] < area_info[:captive_range]
    elsif area_info[:enemy_visible]
      area_info[:clear_shot] = true 
    else
      area_info[:clear_shot] = false
    end

    area_info
  end

  def do_walk(warrior)
    @hit_the_wall ? feel_forward(warrior) : feel_backward(warrior)
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
