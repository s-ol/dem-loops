{graphics: lg} = love

import Loop           from require "schedulor.loop"
import hsl2rgb        from require "schedulor.color"
import DemoLoop, iter from require "demoloop"

class Fracture extends DemoLoop
  new: =>
    super!

    @background = {hsl2rgb love.math.random!, love.math.random!/3+.2, love.math.random!/4}
    @colors = [{hsl2rgb love.math.random!, love.math.random!/3+.4, love.math.random!/3+.3, 1} for i=1,4]

    @splits = 6
    @innerangle = 1/@splits * math.pi * 2
    @triangle = love.graphics.newMesh do 
      x = math.cos @innerangle
      y = math.sin @innerangle
      {
        { 0,  0 }
        { x,  y },
        { x, -y}
      }, nil, "static"

    @time = 0

  update: (dt) =>
    super dt

    @time += dt
    if @time > 8
      true

  draw: =>
    width, height = lg.getDimensions!
    lg.translate width/2, height/2
    lg.scale 120

    for i=1,@splits
      lg.setColor @colors[i] or 255, 255, 255
      lg.draw @triangle
      lg.rotate math.pi*2/@splits
