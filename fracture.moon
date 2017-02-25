{graphics: lg} = love

import Loop           from require "schedulor.loop"
import hsl2rgb        from require "schedulor.color"
import DemoLoop, iter from require "demoloop"

class Fracture extends DemoLoop
  length: 8
  new: =>
    super!

    @background = {hsl2rgb love.math.random!, love.math.random!/3+.2, love.math.random!/4}

    @triangle = {}
    for a = 0, math.pi*2, 2*math.pi/3
      table.insert @triangle, math.cos a
      table.insert @triangle, math.sin a

    @size = 70

    colors = iter [{hsl2rgb love.math.random!, love.math.random!/3+.4, love.math.random!/3+.3, 1} for i=1,4]

    @inner = colors!
    @outer = @inner

    @add Loop 2, @, ->
      set 0, outer: @outer, inner: @inner
      colorease .3, outer: @inner

      max = 1.2 * math.tan 3/math.pi
      ease .3, "quad-in", slide: 0
      ease .6, "quad-out", slide: @size * max
      ease  1, slide: @size * max
      set   1, slide: @size * -max

      untl .6, inner_rot: 0
      ease  1, inner_rot: 2*math.pi/3

      untl  .6, inner: @inner
      colorease 1, inner: colors!
      set  0, inner: @inner

      ease 1, rot: 2*math.pi/3
      set  1, rot: 0

  draw: =>
    width, height = lg.getDimensions!
    lg.setColor @background
    lg.rectangle "fill", 0, 0, width, height

    lg.translate width/2, height/2
    lg.rotate @rot

    -- center
    lg.push!
    lg.scale @size
    lg.setColor @inner
    lg.polygon "fill", @triangle
    lg.pop!

    lg.setColor @outer
    lg.rotate math.pi*2 / 6
    for i=1,3
      lg.push!
      lg.translate .5 * @size, .5 * @slide
      lg.rotate @inner_rot
      lg.scale @size
      lg.translate .5, 0
      lg.polygon "fill", @triangle
      lg.pop!
      lg.rotate math.pi*2 / 3
