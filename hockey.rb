require 'chingu'
require 'chipmunk'

class Hockey < Chingu::Window
  def initialize
    super
    $space = CP::Space.new
    $space.damping = 0.8
    @player = Player.create
    @player.input = {holding_left: :turn_left, holding_right: :turn_right, holding_up: :accelerate}
  end
  def update
    super
    @player.shape.body.reset_forces
  end
end
class Player < Chingu::GameObject
  attr_accessor :shape
  def initialize
    super
    @body = CP::Body.new(10.0, 150.0)
    shape_array = [CP::Vec2.new(-25.0, -25.0), CP::Vec2.new(-25.0, 25.0), CP::Vec2.new(25.0, 1.0), CP::Vec2.new(25.0, -1.0)]
    @shape = CP::Shape::Poly.new(@body, shape_array, CP::Vec2.new(0,0))
    @shape.collision_type = :person
    $space.add_body(@body)
    $space.add_shape(@shape)
    @image = Gosu::Image["person.png"]
    @shape.body.p = CP::Vec2.new(0.0, 0.0) # position
    @shape.body.v = CP::Vec2.new(0.0, 0.0) # velocity
  end
  def turn_left
    @shape.body.t -= 100.0
  end
  def turn_right
    @shape.body.t += 100.0
  end
  def accelerate
    @shape.body.apply_force((@shape.body.a.radians_to_vec2 * (500)), CP::Vec2.new(0.0, 0.0))
  end
  def update
    super
    puts "x: #{@x}, y: #{@y}"
  end
end
class Numeric
  def radians_to_vec2
    CP::Vec2.new(Math::cos(self), Math::sin(self))
  end
end
Hockey.new.show
