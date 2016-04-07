{graphics: lg} = love

import Loop, hsl2rgb from require "schedulor"
import DemoLoop, iter from require "demoloop"

local HOLOSPHERE
class HoloSphere extends DemoLoop
  new: =>
    super!
    HOLOSPHERE = @

    lg.setPointSize 3
    lg.setLineJoin "none"
    lg.setBackgroundColor 100, 100, 100

    background = [{hsl2rgb love.math.random!, love.math.random!/3+.2, love.math.random!/5} for i=1,4]

    @add Loop @, 1, {background[#background]}, {background: iter background}, (g, background) ->
      uuntil 0, :background
      colorease 1, background: g.background

      g.background

    @add Loop @, 1, ->
      custom 1, radius: (old, t) ->
        lg.getWidth!/3 + 5 * math.sin(t*2*math.pi)

    @add Loop @, 6, ->
      uuntil 0, rot: 0
      easeto 6, rot: 2*math.pi

      uuntil 2, retract: 1
      custom 6, retract: (old, t) ->
        1 - 0.3 * math.sin t*math.pi

    @add Loop @, 2, ->
      custom 2, perspective: (old, t) ->
        0.03 * (1.8 + math.sin t*2*math.pi)

    @add Loop @, 4, ->
      uuntil 1, line_alpha: 0
      custom 3, line_alpha: (old, t) ->
        255 * math.sin math.pi * t
      uuntil 4, line_alpha: 0

    @add Loop @, 8, ->
      uuntil 1, sphere_alpha: 1
      easeto 2, sphere_alpha: 0
      uuntil 4, sphere_alpha: 0
      easeto 5, sphere_alpha: 1

      custom 2, sphere_retract: (old, t) ->
        .5 + .5 * math.cos t*math.pi/2
      uuntil 4, sphere_retract: 1
      custom 6, sphere_retract: (old, t) ->
        .5 + .5 * math.sin t*math.pi/2
      uuntil 7, sphere_retract: 1

    segs = {7, 10, 10, 10, 15, 9, 7, 11, 19}
    rings = {13, 20, 20, 20, 11, 15, 13, 13}
    sphere_colors = [ {hsl2rgb love.math.random!, love.math.random!/3+.2, love.math.random!/3+.1, 1} for _ in *segs ]
    wire_colors   = [ {hsl2rgb love.math.random!, love.math.random!/3+.6, love.math.random!/3+.6}     for _ in *rings ]

    @add Loop @, 8, ->
      uuntil 0, sphere_color: sphere_colors[#sphere_colors], segs: segs[#segs]

      space "jump", :segs
      space "colorease", sphere_color: sphere_colors

    @add Loop @, 8, ->
      uuntil 0, wire_color: wire_colors[#wire_colors], rings: rings[#rings]

      space "jump", :rings
      space "colorease", wire_color: wire_colors

  rebuild: =>
    vertices = {}
    add_vert = (elevation, angle) ->
      table.insert vertices, {
        math.cos(elevation) * math.cos(angle),
        math.sin(elevation),
        math.cos(elevation) * math.sin(angle),
        unpack @wire_color
      }
      #vertices

    mid = (@rings - 1) / 2
    rings = for r=0, @rings-1
      elevation = math.pi/2 - r * math.pi / (@rings-1)
      segments = @segs * (mid - math.abs mid - r)

      if math.pi/2 == math.abs elevation
        {add_vert elevation, 0}
      else
        for n=0, segments-1
          add_vert elevation, n * 2*math.pi / segments

    mesh = lg.newMesh {{"VertexPosition", "float", 2}, {"VertexColor", "float", 3}}, #vertices, "points", "stream"
    @sphere = {:vertices, :mesh, :rings}
    @lrings, @lsegs = @rings, @segs

  update_mesh: (sphere, rot) =>

  time: 0
  update: (dt) =>
    done = super dt

    if @lsegs != @segs or @lrings != @rings
      @rebuild!

    verts = for vert in *@sphere.vertices
      {x, y, z, r, g, b} = vert
      rotx = math.cos(@rot) * x + math.sin(@rot) * z
      rotz = math.sin(@rot) * x - math.cos(@rot) * z

      alpha = math.atan2 rotz, rotx
      dy = math.sqrt(x*x + z*z) * math.sin alpha

      y -= @perspective * dy
      dy = math.max 0, dy*.7
      r, g, b = r/255 - dy, g/255 - dy, b/255 - dy
      {rotx*@radius*@retract, y*@radius*@retract, r, g, b}

    @sphere.mesh\setVertices verts
    done

  draw: =>
    width, height = lg.getDimensions!
    lg.setColor @background
    lg.rectangle "fill", 0, 0, width, height

    lg.translate width/2, height/2

    {r, g, b, a} = @sphere_color
    lg.setColor r, g, b, a*@sphere_alpha
    lg.circle "fill", 0, 0, @radius*@retract*@sphere_retract, @radius * 200

    lg.setColor @wire_color
    lg.draw @sphere.mesh

    {r, g, b} = @wire_color
    love.graphics.setColor r, g, b, @line_alpha
    for ring in *@sphere.rings
      if #ring > 2
        verts = [select c, @sphere.mesh\getVertex i for i in *ring for c=1,2]
        verts[#verts+1], verts[#verts+2] = verts[1], verts[2]
        lg.line verts

    for s=0,@segs-1
      verts = for i,r in ipairs @sphere.rings
        n = math.floor #r / @segs
        r[1 + n*s]

      if #verts > 2
        lg.line [select c, @sphere.mesh\getVertex i for i in *verts for c=1,2]

if DEBUG then love.keypressed = (key) ->
  switch key
    when "up"     then HOLOSPHERE.segs += 1
    when "down"   then HOLOSPHERE.segs -= 1
    when "left"   then HOLOSPHERE.rings -= 1
    when "right"  then HOLOSPHERE.rings += 1
  HOLOSPHERE\rebuild!

HoloSphere
