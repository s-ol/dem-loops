{graphics: lg} = love

import hsl2rgb  from require "schedulor.color"
import DemoLoop from require "demoloop"

class TwistedDemo extends DemoLoop
  new: =>
    super!
    @reset!

  reset: =>
    love.math.setRandomSeed 21
    @background = {hsl2rgb love.math.random!, love.math.random!/3+.2, love.math.random!/4}
    lg.setBackgroundColor @background
    hue = love.math.random!
    @shades = setmetatable {}, __index: (key) => with val = { hsl2rgb hue, .7, key * .3 + .1} do rawset @, key, val

    @time = 0

  update: (dt) =>
    super dt

    @time += dt

    @time >= math.pi*2

  draw: =>
    width, height = lg.getDimensions!
    lg.translate width/2, height/2 + 60

    draw = (i) ->
      love.graphics.push!
      love.graphics.translate 0, -120*i
      love.graphics.scale 1, 0.5
      love.graphics.scale 1 - 0.1 * math.sin @time + i*2
      love.graphics.scale 0.8 - i * .4 * math.cos @time
      love.graphics.rotate @time/4
      love.graphics.rotate i * .6 * math.cos @time
      love.graphics.setColor @shades[i]
      love.graphics.rectangle "fill", -80, -80, 160, 160
      love.graphics.pop!

    for i=0,1,1/(20 + 19 * math.cos @time)
      draw i
    draw 1
