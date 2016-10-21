{graphics: lg} = love

import hsl2rgb  from require "schedulor.color"
import DemoLoop from require "demoloop"

class Fracture extends DemoLoop
  new: =>
    super!

    @background = {hsl2rgb love.math.random!, love.math.random!/3+.2, love.math.random!/4}
    @colors = [ [{hsl2rgb love.math.random!, love.math.random!/3+.4, i} for i=0.1,0.3,0.05] for i=1,6]

    @splits = 6
    @innerangle = math.pi*2/@splits
    @triangle = love.graphics.newMesh do
      x = math.cos @innerangle/2
      y = math.sin @innerangle/2
      {
        { 0,  0 },
        { x,  y },
        { x, -y },
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

    seperation = @time/4

--    lg.translate seperation, 0
--    for i=1,6
--      lg.setColor @colors[i] or 255, 255, 255
--      lg.draw @triangle
--      --lg.arc "fill", 0, 0, 1, -@innerangle/2, @innerangle/2
--      lg.rotate math.pi*2/@splits
--      lg.translate seperation * math.sin(@innerangle/2), seperation * math.cos(@innerangle/2)

    for i=1,6
      lg.push!
      lg.rotate math.pi*2/@splits * i

      partsep = seperation/5
      for shade=1,5 do
        lg.setColor @colors[i][shade]
        lg.translate partsep, 0
        lg.draw @triangle
        --lg.arc "fill", 0, 0, 1, -@innerangle/2, @innerangle/2

      lg.pop!
