{graphics: lg} = love

import hsl2rgb  from require "schedulor.color"
import DemoLoop from require "demoloop"

class Fracture extends DemoLoop
  new: =>
    super!

    @background = {hsl2rgb love.math.random!, love.math.random!/3+.2, love.math.random!/4}
    @colors = for i=1,6
      hue, sat = love.math.random!, love.math.random!/3 + .4
      [{hsl2rgb hue, sat, l} for l=0.1,0.3,0.03]

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

    if @time > 18
      @time -= 18
      true

  draw_triangle: (side, shade, center_dist=0, add_rot=0) =>
    lg.push!
    lg.rotate @innerangle * side + add_rot
    lg.translate center_dist, 0
    lg.setColor @colors[side][shade]
    lg.draw @triangle
    --lg.arc "fill", 0, 0, 1, -@innerangle/2, @innerangle/2
    lg.pop!

  draw: =>
    width, height = lg.getDimensions!
    lg.translate width/2, height/2
    lg.scale width/1.3

    seperation = @time/20
    steps = @time*2
    rot = 4 * (math.pow(2, math.max 0,seperation - 0.25) - 1)

    for i=1,6 do @draw_triangle i, 1, nil, rot

    if steps < 32
      for shade=1, math.min 6, 1+steps
        for i=1,6
          @draw_triangle i, shade + 1, shade/15, (6-shade)/6*rot
    else
      for shade=1, math.min 6, 1+steps
        thresh = 37 - 5 * math.pow 0.8, shade
        anim = math.max 0, math.min 1, thresh - steps
        for i=1,6
          @draw_triangle i, shade + 1, shade/15 * anim, (6-shade)/6*rot

    for i=1,6 do @draw_triangle i, 7, seperation
