{graphics: lg} = love

import Loop, hsl2rgb from require "schedulor"
import DemoLoop, iter from require "demoloop"

class Zoom extends DemoLoop
  new: =>
    super!

    @square = {}

    colors = [ [{hsl2rgb love.math.random!, love.math.random!/3+.3, love.math.random!/3+.3} for x=1,4] for y=1,3]

    @square.a, @square.b, @square.c = unpack colors[#colors] -- start with the same colors we end with

    @add Loop @square, 1, {@square.a, @square.b, @square.c}, {colors: iter(colors), dir: iter {1, -1}}, (a, b, c) =>
      max_size = math.sqrt(2) * math.max lg.getDimensions!
      {new_a, new_b, new_c, new} = @colors

      uuntil    0, a: c,     b: a,     c: b       -- shift colors from last iteration to next stage
      colorease 1, a: new_a, b: new_b, c: new_c   -- and fade to random new colors

      uuntil 0, rot: @dir * -math.pi/4
      easeto 1, rot: @dir * math.pi/4

      uuntil 0, inner_radius: max_size/4-1        -- fade corner radius from circle to square
      easeto 1, inner_radius: 0

      uuntil 0, outer_size: max_size/2, inner_size: 0
      easeto 1, outer_size: max_size,   inner_size: max_size/2

      last "a", "b", "c"                          -- pass new end values to next iteration

    @add Loop @, 6, ->
      uuntil 0, rot: 0                            -- global rotation
      easeto 6, rot: math.pi

      uuntil 0, xoffset: 0                        -- swivel the center around a bit
      custom 6, xoffset: (old, t) ->
        lg.getWidth!/5 * math.sin t*2*math.pi

  draw: =>
    {:a, :b, :c, :inner_size, :outer_size, :inner_radius, :rot} = @square
    width, height = lg.getDimensions!

    lg.setColor c                                 -- background / outmost "square"
    lg.rectangle "fill", 0, 0, width, height

    lg.translate width/2 + @xoffset, height/2
    lg.rotate @rot

    lg.setColor b                                 -- middle square
    lg.rotate rot
    lg.rectangle "fill", -outer_size/2, -outer_size/2, outer_size, outer_size

    lg.setColor a                                 -- inner square / circle
    lg.rotate -2*rot
    inner_radius = math.min inner_radius, inner_size/2
    lg.rectangle "fill", -inner_size/2, -inner_size/2, inner_size, inner_size, inner_radius, inner_radius
