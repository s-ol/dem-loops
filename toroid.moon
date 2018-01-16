{ graphics: lg } = love

import hsl2rgb  from require "schedulor.color"
import DemoLoop from require "demoloop"

lg.setLineJoin 'none'
lg.setBlendMode 'lighten', 'premultiplied'

torus = (loops, edge) ->
  a, b = 1, loops
  if loops < 1
    a, b = 1/b, 1/a

  stepsize = edge * math.max(a,b)

  return for i=-1,1,2/stepsize
    phi = i * math.pi * a
    the = i * math.pi * b
    kl_z = math.cos(the)
    kl_x = math.cos(phi) * math.sin(the)
    kl_y = math.sin(phi) * math.sin(the)
    {
      math.cos(phi) + kl_x * 0.6,
      math.sin(phi) + kl_y * 0.6,
      kl_z,
    }

class Toroid extends DemoLoop
  length: math.pi*4

  draw: =>
    three_d = torus math.pow(2, 4 * math.sin(@time/2)), 600

    w, h = lg.getDimensions!
    lg.setColor 0, 0, 0
    lg.rectangle 'fill', 0, 0, w, h

    scale = 0.3 * math.min w, h
    lg.translate w/2, h/2

    x_z, y_z = math.sin(@time*1.5) * 0.2, 0.2 + 0.2 * math.sin @time
    for i,p in ipairs three_d
      x = scale * (p[1] + p[2] * x_z)
      y = scale * (p[3] + p[2] * y_z)

      c = 0.7 + p[2] * 0.27
      r, g, b = hsl2rgb (@time/2)%1, c, 0.5, 255
      --lg.setColor(c*66, c*244, c*98)
      lg.setColor c*r, c*g, c*b
      lg.circle 'fill', x, y, (p[2] + 3) * scale / 30
