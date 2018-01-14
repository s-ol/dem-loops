{ graphics: lg } = love

import hsl2rgb  from require "schedulor.color"
import DemoLoop from require "demoloop"

lg.setBlendMode 'lighten', 'premultiplied'
lg.setBackgroundColor 0, 0, 0, 255

class Infinity extends DemoLoop
  length: 6

  draw: =>
    w, h = lg.getDimensions!
    lg.setColor 0, 0, 0
    lg.rectangle 'fill', 0, 0, w, h

    lg.translate w/2, h/2
    scale = 0.5 * math.min w, h

    pos = @time/2 % 1

    for i=0,1,.002
      x = math.cos i * math.pi*2
      y = 0.6 * (math.sin i * math.pi*4) * math.sin(x/2 + @time * math.pi / 3)

      n = pos - i
      n += 1 if n < -0.5
      n -= 1 if n > 0.5

      rad = 10 + 35 * math.pow (math.abs n * 1.5), 2.3
      c = 2 * 255 * math.abs n

      lg.setColor c, c, c
      lg.circle 'fill', x*scale, y*scale, rad
