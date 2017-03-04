{graphics: lg, math: lm} = love

import DemoLoop, hsl2rgb from require 'demoloop'

SIDES = 6
DRIFT = 2
STEP_LENGTH = 0.8
STEPS = SIDES + DRIFT

makepoly = (sides) -> {
    :sides
    center_angle: 2*math.pi/sides
    edge_length: math.sin(math.pi / sides)
    corner_angle: math.pi*(sides - 2)/sides
    verts: with verts = {}
      for angle=0,2*math.pi,2*math.pi/sides
        table.insert verts, math.cos angle
        table.insert verts, math.sin angle
  }

class PlanetaryDemo extends DemoLoop
  length: STEPS * STEP_LENGTH
  sides: { 4, 5, 4, 3, 4, 5, 4, 3 }
  new: =>
    super!
    lm.setRandomSeed 3

    hues = for i=1, STEPS do lm.random!
    @backgrounds = [{hsl2rgb hues[i], .2, .2} for i=1, STEPS]
    @innerz = [{hsl2rgb hues[i], .4, .28} for i=1, STEPS]
    @inners = [{hsl2rgb hues[i], .45, .3} for i=1, STEPS]
    @outers = [{hsl2rgb hues[i], .6, .4} for i=1, STEPS]

  draw: =>
    step, i = math.floor(@time / STEP_LENGTH), (@time % STEP_LENGTH)/STEP_LENGTH

    width, height = lg.getDimensions!
    lg.setColor @backgrounds[step + 1]
    lg.rectangle 'fill', 0, 0, width, height

    inner = makepoly SIDES
    outer = makepoly @sides[step + 1]

    lg.translate width/2, height/2
    outer_pos = (@time - STEP_LENGTH/2)/@length * 2*math.pi
    lg.translate -.1*width*math.cos(outer_pos), -.1*height*math.sin outer_pos

    lg.scale width/5
    lg.rotate -@time/@length * DRIFT * inner.center_angle

    lg.setColor @inners[step + 1]
    lg.polygon 'fill', inner.verts
    lg.setColor @backgrounds[step + 1]
    lg.circle 'fill', 0, 0, 0.4, 100

    lg.push!
    inner_rad = 0.1

    lg.rotate math.pi + (@time - STEP_LENGTH/2)/@length * 2*math.pi * STEPS/SIDES
    --lg.setColor @innerz[step + 1]
    lg.setColor @inners[step + 1]
    lg.circle 'fill', 0.4 - inner_rad, 0, inner_rad, 20
    lg.pop!

    lg.rotate step * inner.center_angle -- rotate to current outer polygon position
    lg.translate 1, 0                   -- align with vertex
    lg.rotate inner.corner_angle/2      -- align with outer edge
    lg.rotate i * (2*math.pi - inner.corner_angle - outer.corner_angle) -- rotate outer polygon

    -- draw outer polygon
    lg.setColor @outers[step + 1]
    lg.scale inner.edge_length/outer.edge_length
    lg.rotate outer.corner_angle/2
    lg.translate -1, 0
    lg.polygon 'fill', outer.verts
    lg.setColor @backgrounds[step + 1]
    lg.circle 'fill', 0, 0, 0.1 + outer.sides/30, 100
