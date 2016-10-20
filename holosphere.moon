{graphics: lg} = love

import Loop, hsl2rgb from require "schedulor"
import DemoLoop from require "demoloop"

local HOLOSPHERE
with class HoloSphere extends DemoLoop
    new: =>
      super!
      HOLOSPHERE = @

      lg.setPointSize 4
      lg.setLineJoin "none"
      lg.setBackgroundColor 0, 0, 0, global_alpha

      @rot = 0
      @seperation = 0
      @perspective = 0
      @segs, @rings = 5, 6

      @rebuild!

      sphere_colors = [ {hsl2rgb love.math.random!, love.math.random!/3+.3, love.math.random!/3+.3, 50} for y=1,9]
      wire_colors   = for y=1,6
        hue = love.math.random!
        {
          one: {hsl2rgb hue, love.math.random!/3+.6, love.math.random!/3+.6}
          two: {hsl2rgb (hue+.5)%1, love.math.random!/3+.6, love.math.random!/3+.6}
        }

      @add Loop @, 1, ->
        custom 1, radius: (old, t) ->
          100 + 5 * math.sin(t*2*math.pi)

      @add Loop @, 6, ->
        uuntil 0, rot: 0                            -- global rotation
        easeto 6, rot: 2*math.pi

        uuntil 3, seperation: 0, retract: 1
        custom 6, seperation: (old, t) ->
          lg.getWidth!/10 * math.sin(t*2*math.pi) * math.sin t*math.pi

        custom 6, retract: (old, t) -> 1 - 0.5 * math.sin t*math.pi

      @add Loop @, 2, ->
        custom 2, perspective: (old, t) ->
          0.03 * (1.8 + math.sin t*2*math.pi)

      @add Loop @, 7, ->
        space "jump", segs: {7, 4, 3, 2, 2, 2, 3, 4, 5}
        space "jump", sphere_color: sphere_colors

      @add Loop @, 6, ->
        space "jump", rings: {3, 2, 4, 7, 8, 5}
        space "jump", wire_colors: wire_colors

    rebuild: =>
      @one = @build_sphere @rings + 1, @segs + 1, false
      @two = @build_sphere @rings, @segs
      @lsegs = @segs
      @lrings = @rings

    build_sphere: (rings, subdivisions, ends=true) =>
      vertices = {}
      add_vert = (elevation, angle) ->
        table.insert vertices, {
          math.cos(elevation) * math.cos(angle),
          math.sin(elevation),
          math.cos(elevation) * math.sin(angle),
          1, 1, 1
        }
        #vertices

      mid = (rings - 1) / 2
      rings = for r=0, rings-1
        elevation = math.pi/2 - r * math.pi / (rings-1)
        segments = subdivisions * (mid - math.abs mid - r)

        if ends and math.pi/2 == math.abs elevation
          add_vert elevation, 0
          continue
        else
          for n=0, segments
            add_vert elevation, n * 2*math.pi / segments

      mesh = lg.newMesh {{"VertexPosition", "float", 2}, {"VertexColor", "float", 3}}, #vertices, "points", "stream"
      {:vertices, :mesh, :rings}

    update_mesh: (sphere, rot) =>
      verts = for vert in *sphere.vertices
        {x, y, z, r, g, b} = vert
        rotx = math.cos(rot) * x + math.sin(rot) * z
        rotz = math.sin(rot) * x - math.cos(rot) * z

        alpha = math.atan2 rotz, rotx
        dy = math.sqrt(x*x + z*z) * math.sin alpha

        y -= @perspective * dy
        c = 1 - dy * .7
        {rotx*150, y*150, c, c, c}

      sphere.mesh\setVertices verts

    update: (dt) =>
      done = super dt
      if @lsegs != @segs or @lrings != @lrings
        @rebuild!
      @update_mesh @one, @rot
      @update_mesh @two, -@rot
      done

    draw: =>
      width, height = lg.getDimensions!

      lg.translate width/2, height/2

      lg.setColor @sphere_color
      lg.circle "fill", 0, 0, @radius*@retract, @radius * 200

      lg.push!
      lg.translate @seperation, 0
      lg.setColor 255, 100, 100
      lg.setColor @wire_colors.one
      lg.draw @one.mesh

      for ring in *@one.rings
        if #ring > 2
          lg.line [select c, @one.mesh\getVertex i for i in *ring for c=1,2]

      lg.pop!
      lg.translate -@seperation, 0
      lg.setColor @wire_colors.two
      lg.draw @two.mesh

      for ring in *@two.rings
        if #ring > 2
          lg.line [select c, @two.mesh\getVertex i for i in *ring for c=1,2]

  if DEBUG then love.keypressed = (key) ->
    switch key
      when "up"     then HOLOSPHERE.segs += 1
      when "down"   then HOLOSPHERE.segs -= 1
      when "left"   then HOLOSPHERE.rings -= 1
      when "right"  then HOLOSPHERE.rings += 1
    HOLOSPHERE\rebuild!
