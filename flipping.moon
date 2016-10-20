{graphics: lg} = love

import Loop           from require "schedulor.loop"
import hsl2rgb        from require "schedulor.color"
import DemoLoop, iter from require "demoloop"

class Flipping extends DemoLoop
  new: =>
    super!

    lg.setLineWidth .02

    colors = [{hsl2rgb love.math.random!, love.math.random!/3+.3, love.math.random!/3+.3} for x=1,6]
    color = iter colors
    @color = color!

    @background = {hsl2rgb love.math.random!, love.math.random!/3+.2, love.math.random!/4}

    @triangle = {}
    table.insert @triangle, .75 * math.cos 0 + math.pi/6 - math.pi/8
    table.insert @triangle, .75 * math.sin 0 + math.pi/6 - math.pi/8

    table.insert @triangle, .75 * math.cos 0 + math.pi/6 + math.pi/8
    table.insert @triangle, .75 * math.sin 0 + math.pi/6 + math.pi/8

    table.insert @triangle, math.cos 2*math.pi/3 + math.pi/6
    table.insert @triangle, math.sin 2*math.pi/3 + math.pi/6
    table.insert @triangle, math.cos 4*math.pi/3 + math.pi/6
    table.insert @triangle, math.sin 4*math.pi/3 + math.pi/6

    @rot   = 0
    @maxshear = .4

    @add Loop 4/6, @, ->
      @rot -= math.pi/3

      ease .5, "sine-out", scale: 0
      ease .95, "sine-in", scale: -1
      jump 1, scale: 1

      untl .15, shear: 0
      ease .5, "sine-in", shear: @maxshear
      ease .85, "sine-out", shear: 0

      untl .5, color: @color
      colorease 1, color: color!
      @color2 = @color


      @maxshear = -@maxshear
      ease  1, "sine-out",  ring: .4
      ease .5, "sine-in",   ring: .2

      untl .4, ringrot: 0
      ease .7, ringrot: math.pi/3

    @time = 0
    width, height = lg.getDimensions!
    @size = .25 * math.min width, height, math.sqrt width * width + height * height

  update: (dt) =>
    super dt

    @time += dt
    if @time > 4
      true

  draw: =>
    width, height = lg.getDimensions!
    lg.setColor @background
    lg.rectangle "fill", 0, 0, width, height

    lg.translate width/2, height/2

    lg.push!
    lg.rotate @ringrot
    lg.setColor @color2
    lg.circle "fill", 0, 0, @size * @ring, 6
    lg.pop!

    lg.rotate @rot
    lg.scale 1, @scale
    lg.shear @shear, 0
    lg.translate -@size * 0.87, @size / -2
    lg.scale @size
    lg.setColor @color
    lg.polygon "fill", @triangle
