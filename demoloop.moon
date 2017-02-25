rgb2hsl = (r, g, b, a=255) ->
  r, g, b = r / 255, g / 255, b / 255
  local h, s, l

  max, min = math.max(r, g, b), math.min(r, g, b)
  l = (max + min) / 2

  if max == min
    h, s = 0, 0 -- achromatic
  else
    d = max - min
    s = if l > 0.5 then d / (2 - max - min) else d / (max + min)
    if max == r then
      h = (g - b) / d
      h += 6 if g < b
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    h = h / 6

  h, s, l, a

hue2rgb = (p, q, t) ->
  t += 1 if t < 0
  t -= 1 if t > 1

  if t < 1/6 then p + (q - p) * 6 * t
  elseif t < 1/2 then q
  elseif t < 2/3 then p + (q - p) * (2/3 - t) * 6
  else p

hsl2rgb = (h, s, l, a=1) ->
  local r, g, b

  if s == 0
    r, g, b = l, l, l -- achromatic
  else
    q = if l < 0.5  then l * (1 + s)
                    else l + s - l * s
    p = 2 * l - q

    r = hue2rgb p, q, h + 1/3
    g = hue2rgb p, q, h
    b = hue2rgb p, q, h - 1/3

  r * 255, g * 255, b * 255, a * 255

class DemoLoop
  {graphics: lg, filesystem: fs} = love
  new: =>
    lg.setBackgroundColor 0, 0, 0, 0
    @time = 0
    @loops = {}

  add: (loop) =>
    table.insert @loops, loop

  draw: =>

  update: (dt) =>
    @time += dt

    for loop in *@loops
      if loop\update dt then
        loop.frames_since_done = 3
      elseif loop.frames_since_done
        loop.frames_since_done = loop.frames_since_done - 1

    done = #@loops > 0
    for loop in *@loops
      if not loop.frames_since_done or loop.frames_since_done < 0
        done = false
        break

    if @length and @time > @length
      @time -= @length
      done = true

    @done or= done
    @done

  render: (fps=60, dirname=@@__name, overwrite=false) =>
    fs.setIdentity "demöloop"
    if overwrite
      for file in *fs.getDirectoryItems dirname
        fs.remove dirname .. "/" .. file
      fs.remove dirname
    else
      while fs.exists dirname
         dirname ..= "_"

    dt = 1/fps

    fmt = "#{dirname}/%06d.png"
    fs.createDirectory dirname
    print fs.getSaveDirectory! .. "/" .. dirname

    love.run = ->
      frame = 0
      while true
        love.event.pump!
        for name, a,b,c,d,e,f in love.event.poll!
          if name == "quit"
            return
          love.handlers[name] a,b,c,d,e,f

        break if @update dt

        lg.clear lg.getBackgroundColor!
        lg.origin!
        @draw!
        lg.newScreenshot(true)\encode "png", fmt\format frame

        lg.present!
        frame += 1

  run: =>
    love.draw   = @\draw
    love.update = @\update

iter = (table) ->
  index = -1
  len = #table
  ->
    index = (index + 1)%len
    table[index+1]

{
  :DemoLoop,
  :iter,
  :rgb2hsl,
  :hsl2rgb
}
