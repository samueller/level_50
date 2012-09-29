#require 'rubygems' rescue nil
#$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
require 'chipmunk'
#include Gosu

class Asteroids < Chingu::Window
  def initialize
    super
    push_game_state(Levels)
  end
end

class Levels < Chingu::GameState
  def initialize
    super
    @space = CP::Space.new
    @space.damping = 0.8

    $right_edge = $window.width + 50
    $left_edge = -50
    @asteroids = 0
    @player = Player.create
    @player.input = {space: :fire, holding_a: :move_left, holding_d: :move_right, holding_w: :move_up, holding_s: :move_down, holding_left: :turn_left, holding_right: :turn_right}
    8.times do
      Asteroid.create
      @asteroids += 1
    end
  end

  def update
    super
    @space.step(1.0/60)
    #Bullet.each_collision(Asteroid) do |bullet, asteroid|
    #  asteroid.destroy
    #  bullet.destroy
    #  @player.score += 1
    #  if (@asteroids -= 1) <= 0
    #    push_game_state GameOver.new("You won!")
    #  end
    #end
    #Player.each_collision(Asteroid) do |player, asteroid|
    #  push_game_state GameOver.new("Game Over")
    #end
    $window.caption = "Score: #{@player.score}"
  end

=begin
  def draw
    super
    @color = Gosu::Color.new(0x99000000)
    $window.draw_quad(  0,0,@color,
                        $window.width,0,@color,
                        $window.width,$window.height,@color,
                        0,$window.height,@color, Chingu::DEBUG_ZORDER)
  end
=end
end

class GameOver < Chingu::GameState
  def initialize(message)
    super
    @message = message
  end
  def draw
    super
    previous_game_state.draw
    @color = Gosu::Color.new(0x99000000)
    @font = Gosu::Font[35]
    $window.draw_quad(  0,0,@color,
                        $window.width,0,@color,
                        $window.width,$window.height,@color,
                        0,$window.height,@color, 100)
    @font.draw(@message, ($window.width/2 - @font.text_width(@message)/2), $window.height/2 - @font.height/2, 100)
  end
end

class Bullet < Chingu::GameObject
  #traits :collision_detection, :bounding_circle
  def initialize(player)
    super(image: Gosu::Image["bullet_small.png"])
    @player = player
    @x = player.x
    @y = player.y
    @time = 0
    @angle = player.angle
    @angle_radians = player.angle * Math::PI / 180
    @speed = 8
    @half_width = @image.width/2
    @half_height = @image.height/2
    #cache_bounding_circle
  end

  def update
    super
    @time += 1
    destroy if @time > 100
    #destroy if @x < 0 - @half_width or @y < 0 - @half_height or @x > $window.width + @half_width or @y > $window.height + @half_height
    @x = (@x - @speed * Math::cos(@angle_radians)) % $window.width
    @y = (@y - @speed * Math::sin(@angle_radians)) % $window.height
  end

=begin
  def destroy
    @player.bullets -= 1
    super
  end
=end
end

class Player < Chingu::GameObject
  #traits :collision_detection, :bounding_circle
  #attr_accessor :bullets
  attr_accessor :score

  def initialize
    super(image: Gosu::Image["person.png"])
    @score = 0
    #@bullets = 0
    #@half_width = (@image.width-25)/2
    #@half_height = (@image.height-3)/2
    @x = $window.width/2
    @y = $window.height/2
    cache_bounding_circle
  end

  def fire
    Bullet.create(self)
    #@bullets += 1
  end

  def move_left
    #@x -= 4
    #@x = @half_width if @x < @half_width
    @x = (@x - 4) % $window.width
  end
  def move_right
    #@x += 4
    #@x = $window.width - @half_width if @x > $window.width - @half_width
    @x = (@x + 4) % $window.width
  end

  def move_up
    #@y -= 4
    #@y = @half_height if @y < @half_height
    @y = (@y - 4) % $window.height
  end
  def move_down
    #@y += 4
    #@y = $window.height - @half_height if @y > $window.height - @half_height
    @y = (@y + 4) % $window.height
  end

  def turn_left
    @angle -= 4
  end
  def turn_right
    @angle += 4
  end
end

class Asteroid < Chingu::GameObject
  traits :collision_detection, :bounding_circle
  def initialize
    super(image: Gosu::Image["asteroid.png"])
    #@bullets = 0
    #@half_width = (@image.width-25)/2
    #@half_height = (@image.height-3)/2
    @x = rand(0..$window.width/10)
    @y = rand(0..$window.height-1)
    @x_speed = rand(-2..2)
    @y_speed = rand(-2..2)
    @angle = rand(0..359)
    @angular_speed = rand(1..10)
    cache_bounding_circle
  end

  def update
    super
    @angle += @angular_speed
    @x = (@x + @x_speed) % $window.width
    @y = (@y + @y_speed) % $window.height

  end
end


Asteroids.new.show