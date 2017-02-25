{graphics: lg} = love

import Loop           from require "schedulor.loop"
import hsl2rgb        from require "schedulor.color"
import DemoLoop, iter from require "demoloop"

class Circle extends DemoLoop
  length: 3
  new: =>
    super!

    love.math.setRandomSeed 420

    @large_color = {hsl2rgb love.math.random!, love.math.random!/3+.3, love.math.random!/3+.3}
    slice_color = {hsl2rgb love.math.random!, love.math.random!/3+.3, love.math.random!/3+.3}
    @background = {hsl2rgb love.math.random!, love.math.random!/3+.2, love.math.random!/4}

    width, height = lg.getDimensions!
    @size = .25 * math.min width, height, math.sqrt width * width + height * height

    @add Loop 3, @, ->
      set  0, slice: 0
      ease .4, "quad-in", slice: .2
      ease .9, "quad-out", slice: 2

      untl .4, grow: 0.7
      ease  1, "quad-in", grow: 1

      untl .3, trans: 0
      ease .8, "quad-out", trans: 4*@size
      jump  1, trans: 0

      untl .6, scale: 1
      ease .8, scale: 0

      untl .4, flip:  1
      ease .6, "quad-in", flip: -1

      set 0, :slice_color
      untl .6, :slice_color
      colorease .9, slice_color: @large_color

  draw: =>
    width, height = lg.getDimensions!
    lg.setColor @background
    lg.rectangle "fill", 0, 0, width, height

    lg.translate width/2 - @trans, height/2

    lg.push!
    lg.setColor @large_color
    lg.rotate @slice*math.pi/2
    lg.scale @scale
    lg.arc "fill", 0, 0, @size, 0, (2-@slice)*math.pi
    lg.pop!

    lg.push!
    lg.translate @trans, 0
    lg.setColor @slice_color
    lg.scale 1, @flip
    lg.rotate @slice*math.pi/2
    lg.arc "fill", 0, 0, @size*@grow, 0, (-@slice) *math.pi
    lg.pop!
