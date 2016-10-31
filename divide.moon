{graphics: lg} = love

import Loop           from require "schedulor.loop"
import hsl2rgb        from require "schedulor.color"
import DemoLoop, iter from require "demoloop"

class Divide extends DemoLoop
  STAGGER = 0.6
  HEXAGON = {}
  for angle=math.pi/6,2*math.pi,math.pi/3
    table.insert HEXAGON, math.cos angle
    table.insert HEXAGON, STAGGER * math.sin angle

  HSPACE = math.sqrt 3
  VSPACE = STAGGER * 2 * 3/4
  SIZE = 30

  RX = 3
  RY = 4

  new: =>
    super!

    lg.setLineWidth .02

    colors = [{hsl2rgb love.math.random!, love.math.random!/3+.3, love.math.random!/3+.3} for x=1,6]
    color = iter colors
    @color = color!

    @background = {hsl2rgb love.math.random!, love.math.random!/3+.2, love.math.random!/4}

    @time = 0

  update: (dt) =>
    super dt

    @time += dt
    if @time > 9
      true

  g2c: (x, y) =>
    cx = x - math.ceil y / 2
    cz = y
    cy = -cx - cz
    cx, cy, cz

  light: (t, dist, offset) =>
    tt = math.max 0, t - 0.6 - dist/30
    math.min 1, 0.03/t + offset + math.max 0, 2 * math.pow tt, 2

  draw: =>
    width, height = lg.getDimensions!
    lg.setColor @background
    lg.rectangle "fill", 0, 0, width, height

    lg.translate width/2, height/2

    t = (@time%9)/6

    lg.scale SIZE
    lg.translate -HSPACE/2, -VSPACE/2
    for y = -8, 8
      for x = -5, 5
        cx, cz, cy = @g2c x, y
        dist = do
          rx, ry, rz = @g2c -1, -5
          (math.abs(rx - cx) + math.abs(ry - cy) + math.abs(rz - cz))/2

        lg.push!
        if y % 2 == 0 then lg.translate 0.5 * HSPACE, 0
        lg.translate x * HSPACE, y * VSPACE

        if x + y > -1
          lg.translate 0, t
        if x == RX and y == RY
          lg.translate 0, -2 * math.pow math.max(0, t - 0.2), 3

        hue = ((x * math.cos(t*math.pi*2) + 5 + y*math.sin(t*math.pi*4 + .5) + 8) / 26 + t) % 1
        lg.setColor hsl2rgb hue, 0.5, @light t, dist, 0.3
        lg.rectangle "fill", -HSPACE/2, 0, HSPACE, 10
        -- lg.scale 0.95
        if x == RX and y == RY
          lg.setColor hsl2rgb hue, 0.5 + t*t, @light t, dist, 0.5
        else
          lg.setColor hsl2rgb hue, 0.5, @light t, dist, 0.5
        lg.polygon "fill", HEXAGON
        lg.pop!
