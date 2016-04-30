{graphics: lg} = love

import Loop           from require "schedulor.loop"
import hsl2rgb        from require "schedulor.color"
import DemoLoop, iter from require "demoloop"

class Triangles extends DemoLoop
  new: =>
    super!

    backgrounds = iter [{hsl2rgb love.math.random!, love.math.random!/3+.2, love.math.random!/4} for i=1,4]
    ones = iter [ {hsl2rgb love.math.random!, love.math.random!/3+.4, love.math.random!/3+.3, 1} for i=1,4]
    twos = iter [ {hsl2rgb love.math.random!, love.math.random!/3+.4, love.math.random!/3+.3, 1} for i=1,4]

    @background = backgrounds!
    @one, @two = ones!, twos!

    @triangle = {}
    table.insert @triangle, math.cos 0 + math.pi/6
    table.insert @triangle, math.sin 0 + math.pi/6
    table.insert @triangle, math.cos 2*math.pi/3 + math.pi/6
    table.insert @triangle, math.sin 2*math.pi/3 + math.pi/6
    table.insert @triangle, math.cos 4*math.pi/3 + math.pi/6
    table.insert @triangle, math.sin 4*math.pi/3 + math.pi/6

    @step_scale = 30
    @scale = 1
    @rot   = 0

    phase = 1
    @add Loop 2, @, ->
      colorease 1, one: ones!, two: twos!, background: backgrounds!
      set  0, one: @one, two: @two, background: @background

      untl 0, scale: 1
      ease .3, scale: 1 / math.sqrt 3
      untl .6, scale: 1 / math.sqrt 3
      ease .9, scale: 1

      untl .1, rot: 0
      ease .8, rot: 2*math.pi/3 * (if phase % 2 == 0 then 1 else -1)

      untl .1, yoffset: 0, xoffset: 0
      switch phase
        when 4
          ease .8, xoffset: 1
        when 2
          ease .8, yoffset: 1
        when 1
          ease .8, xoffset: -1
        when 3
          ease .8, yoffset: -1

      phase = (phase % 4) + 1

    @add Loop 8, @, ->
      untl 0, step_scale: 40
      ease .5, step_scale: 70
      ease 1, step_scale: 40

      ease 1, total_rot: 2*math.pi
      set  0, total_rot: 0

    @time = 0

  update: (dt) =>
    super dt

    @time += dt
    if @time > 8
      true

  draw: =>
    width, height = lg.getDimensions!
    lg.setColor @background
    lg.rectangle "fill", 0, 0, width, height

    lg.setColor @one
    lg.translate width/2, height/2
    lg.rotate @total_rot
    lg.push!
    lg.translate -width/2, -height/2 - 80
    lg.scale @step_scale
    lg.translate -2*@triangle[1], 0
    for y=0,width/@step_scale
      lg.push!
      for x=0,width/@step_scale
        lg.push!
        lg.translate @xoffset*2*@triangle[1], @yoffset*(@triangle[2] - @triangle[6])
        lg.scale @scale
        lg.rotate @rot
        lg.polygon "fill", @triangle
        lg.pop!
        lg.translate 2*@triangle[1], 0
      lg.pop!
      lg.translate 0, @triangle[2] - @triangle[6]
    lg.pop!

    lg.setColor @two
    lg.push!
    lg.rotate math.pi
    lg.translate width/2, height/2 + 80
    lg.scale @step_scale
    lg.translate @triangle[1], (@triangle[2] - @triangle[6])/3
    for y=0,width/@step_scale
      lg.push!
      for x=0,width/@step_scale
        lg.push!
        lg.translate @xoffset*2*@triangle[1], @yoffset*(@triangle[2] - @triangle[6])
        lg.scale @scale
        lg.rotate -@rot
        lg.polygon "fill", @triangle
        lg.pop!
        lg.translate -2*@triangle[1], 0
      lg.pop!
      lg.translate 0, -(@triangle[2] - @triangle[6])
    lg.pop!


Triangles
