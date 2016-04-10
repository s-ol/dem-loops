{graphics: lg} = love

import Loop           from require "schedulor.loop"
import hsl2rgb        from require "schedulor.color"
import DemoLoop, iter from require "demoloop"

class CubeDemo extends DemoLoop
  new: =>
    super!

    @background = {hsl2rgb love.math.random!, love.math.random!/3+.2, love.math.random!/4}

    lg.setBackgroundColor @background
    hue = love.math.random!
    @shades = {key, {hsl2rgb hue, love.math.random!/5+.4, light} for key, light in pairs {front: .7, top: .5, side: .3}}

    @rot = 0
    @rtime = 0
    @length = 2

  update: (dt) =>
    super dt

    STILL = .4
    scale = 2*math.pi/@length

    time = @rtime
    if time < STILL
      time = time * time / STILL
      --@scale = math.min 1, 2 * time * time / STILL / STILL

    @scale = math.max .6, 1.8 * math.cos time * scale 

    if time > @length - STILL
      left = 2 - time
      time = 2 - left * left / STILL
      --@scale = math.min 1, 2 * left * left / STILL / STILL

    @sheara =  2 * math.cos time * scale
    @shearc = .5 * math.cos time * scale
    @shearb =  2 * math.sin time * scale

    @rtime += dt
    if @rtime > @length
      @rtime -= @length
      true

  draw: =>
    width, height = lg.getDimensions!
    lg.translate width/2 - 50, height/2
    lg.scale @scale if @scale

    lg.push!
    lg.translate -50, 0
    lg.setColor @shades.side
    lg.shear @shearb, @shearc
    lg.rotate @rot
    lg.scale .5, 1
    lg.rectangle "fill", 0, -50, 100, 100
    lg.pop!

    lg.push!
    lg.translate 50, -25
    lg.setColor @shades.top
    lg.rotate -@rot
    lg.shear @sheara, @shearb
    lg.scale 1, .5
    lg.rectangle "fill", -50, -50, 100, 50
    lg.pop!

    lg.push!
    lg.translate 50, 25
    lg.setColor @shades.front
    lg.rotate -2*@rot
    lg.shear @shearb, -@shearb
    lg.rectangle "fill", -50, -50, 100, 100
    lg.pop!

CubeDemo
