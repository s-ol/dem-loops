class DemoLoop
  {graphics: lg, filesystem: fs} = love
  new: =>
    lg.setBackgroundColor 0, 0, 0, 0
    @loops = {}

  add: (loop) =>
    table.insert @loops, loop

  draw: =>

  update: (dt) =>
    for loop in *@loops
      if loop\update dt then
        loop.frames_since_done = 3
      elseif loop.frames_since_done
        loop.frames_since_done = loop.frames_since_done - 1

    done = true
    for loop in *@loops
      if not loop.frames_since_done or loop.frames_since_done < 0
        done = false
        break

    @done or= done

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
          love.handlers[name](a,b,c,d,e,f)

        break if @update dt

        lg.clear lg.getBackgroundColor!
        lg.origin!
        @draw!
        lg.present!
        lg.newScreenshot(true)\encode "png", fmt\format frame
        frame += 1

  run: =>
    love.draw   = @\draw
    love.update = @\update

iter = (table) ->
  index = -1
  len = #table
  ->
    index = (index + 1)%len
    index == 0, table[index+1]

{
  :DemoLoop,
  :iter
}
