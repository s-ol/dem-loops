{ graphics: lg, math: lm } = love

import DemoLoop, hsl2rgb from require "demoloop"

class Goldfish extends DemoLoop
  length: 14
  new: =>
    super!

    @layers = require 'goldfish.fish'
    for _, layer in pairs @layers
      for shape in *layer
        shape.seed = math.random!

  draw_layer: (layer, hue) =>
    sin = math.sin @time/@length * math.pi
    for triangle in *layer
      rdm = (scale=1, v) -> scale * (lm.noise(sin, triangle.seed, v) - .5)

      lg.setColor hsl2rgb hue + rdm(.1, .1), rdm(.3, .5) + .4, rdm(.3, .7) + .3
      lg.polygon 'fill', triangle

  draw: =>
    scale = math.max lg.getWidth!/500, lg.getHeight!/400
    lg.translate 0, -150
    lg.scale scale
    t = .6 --(.45 + @time/@length) % 1
    start = 0 -- .5
    duration = .3

    delta = 0
    if @time/@length >= start and t <= start + duration
      delta = (1 - math.cos (t - start)/duration * math.pi*2) / 2 * .2

    @draw_layer @layers.water, t
    @draw_layer @layers.fish, t + delta
