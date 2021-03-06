{graphics: lg} = love

import hsl2rgb  from require "schedulor.color"
import DemoLoop from require "demoloop"

class RoundedSquareGrid extends DemoLoop
  length: 4
  COUNT = 10

  new: =>
    super!
    lg.setBackgroundColor 0, 0, 0, 255

  square: (rad) => lg.rectangle "fill", -.5, -.5, 1, 1, rad/2, rad/2

  draw: =>
    smaller = math.min lg.getDimensions!
    size = math.floor smaller/COUNT

    width, height = lg.getDimensions!
    lg.translate (width%size)/-2, (height%size)/-2

    lg.scale size, size
    lg.translate .5, .5
    for x = 0, width/size
      lg.push!
      for y = 0, height/size
        roundangle = ((@time/@length + x/4 + y/-3) % 1) * 2*math.pi
        sizeangle = ((@time/@length + x/3 + y/4) % 1) * 2*math.pi

        lg.push!
        lg.scale .8 + .2 * math.cos sizeangle
        @square math.sin roundangle/2

        lg.pop!
        lg.translate 0, 1

      lg.pop!
      lg.translate 1, 0
