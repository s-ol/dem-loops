{graphics: lg, math: lm} = love

import hsl2rgb  from require "schedulor.color"
import DemoLoop from require "demoloop"

class TwistedDemo extends DemoLoop
  length: math.pi * 4
  new: =>
    super!
    lm.setRandomSeed 21
    @background = {hsl2rgb lm.random!, lm.random!/3+.2, lm.random!/4}
    lg.setBackgroundColor @background
    hue = lm.random!
    @shades = setmetatable {}, __index: (key) => with val = { hsl2rgb hue, .7, key * .3 + .1} do rawset @, key, val

  draw: =>
    width, height = lg.getDimensions!
    lg.translate width/2, height/2 + 70

    draw = (i) ->
      lg.push!
      lg.translate 0, -120*i
      lg.scale 1, 0.5
      lg.scale 1 - 0.1 * math.sin @time + i*2
      lg.scale 0.8 - i * .4 * math.cos @time
      lg.rotate @time/4
      lg.rotate i * .6 * math.cos @time
      lg.setColor @shades[i]
      lg.rectangle "fill", -80, -80, 160, 160
      lg.pop!

    for i=0,1,1/(20 + 19 * math.sin(@time / 2))
      draw i
    draw 1
