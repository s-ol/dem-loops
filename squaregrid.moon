{graphics: lg} = love

import hsl2rgb  from require "schedulor.color"
import DemoLoop from require "demoloop"

class Zoom extends DemoLoop
  length: 2
  COUNT = 10

  square: => lg.rectangle "fill", -.5, -.5, 1, 1

  draw: =>
    smaller = math.min lg.getDimensions!
    size = math.floor smaller/COUNT

    width, height = lg.getDimensions!
    lg.translate (width%size)/-2, (height%size)/-2

    angle = @time/@length * math.pi/2
    cos, sin = math.cos(angle), math.sin(angle)

    insize = 1 / (cos + sin)

    lg.scale size, size
    lg.translate .5, .5
    for x = 0, width, size
      lg.push!
      for y = 0, height, size
        lg.push!
        lg.rotate angle
        lg.scale insize
        @square!

        lg.pop!
        lg.translate 0, 1

      lg.pop!
      lg.translate 1, 0
