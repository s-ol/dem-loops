{graphics: lg} = love

import Loop           from require "schedulor.loop"
import hsl2rgb        from require "schedulor.color"
import DemoLoop, iter from require "demoloop"

class Dots extends DemoLoop
  new: =>
    super!

    @background = {hsl2rgb love.math.random!, love.math.random!/3+.2, love.math.random!/4}

    @time = 0

  update: (dt) =>
    super dt

    @time += dt * 2

    if @time > 6
      @time -= 6
      true

  draw: =>
    width, height = lg.getDimensions!
    lg.setBlendMode "alpha"
    lg.setColor @background
    lg.rectangle "fill", 0, 0, width, height

    size = math.sqrt width * width + height * height
    ystep = 40 * math.sin math.pi/3

    fade = do
      t = @time % 2
      if t <= 1
        0.5 * t * t
      else
        1 - (2 - t) * (2 - t) / 2

    rad = 8 + 2 * math.cos @time * math.pi

    lg.setBlendMode "add"
    lg.translate width/2, height/2 - 15

    lg.rotate math.pi/3 * math.floor @time/2
    lg.translate 0, -3*ystep/4

    point = (x, y, rev) ->
      if math.floor(@time/2) % 2 == 0
        rev = not rev
      off = if rev then fade*40 else fade*-40
      lg.setColor 255, 0, 0
      lg.circle "fill", x - off, y, rad, 30

      lg.setColor 0, 255, 0
      lg.circle "fill", x, y, rad, 30

      lg.setColor 0, 0, 255
      lg.circle "fill", x + off, y, rad, 30

    for y=-size/2, size/2, 2 * ystep
      for x=-size/2,size/2, 40
          point x, y
          point x + 20, y + ystep, true
