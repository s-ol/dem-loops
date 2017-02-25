local lg, fs = love.graphics, love.filesystem

local DemoLoop = {}
DemoLoop.__index = DemoLoop

function DemoLoop.new()
  local self = setmetatable({}, DemoLoop)
  lg.setBackgroundColor(0, 0, 0, 0)
  self.time = 0
  return self
end

function DemoLoop:update(dt)
  self.time = self.time + dt

  if self.length and self.time > self.length then
    self.time = self.time - self.length
    return true
  end
end

function DemoLoop:render(fps, dirname, overwrite)
  if not fps then fps = 60 end
  if not dirname then dirname = 'UnnamedLoop' end

  fs.setIdentity "demöloop"
  if overwrite then
    for _, file in ipairs(fs.getDirectoryItems(dirname)) do
      fs.remove(dirname .. "/" .. file)
    end
    fs.remove(dirname)
  else
    while fs.exists(dirname) do
      dirname = dirname .. "_"
    end
  end

  local dt = 1/fps

  local fmt = dirname .. "/%06d.png"
  fs.createDirectory(dirname)
  print(fs.getSaveDirectory() .. "/" .. dirname)

  function love.run()
    local frame = 0
    while true do
      love.event.pump()
      for name, a,b,c,d,e,f in love.event.poll() do
        if name == "quit" then return end
        love.handlers[name](a,b,c,d,e,f)
      end

      if self:update(dt) then break end

      lg.clear(lg.getBackgroundColor())
      lg.origin()
      self:draw()
      lg.newScreenshot(true):encode("png", fmt:format(frame))

      lg.present()
      frame = frame + 1
    end
  end
end

function DemoLoop:run()
  function love.draw(...) return self:draw(...) end
  function love.update(...) return self:update(...) end
end

return {
  DemoLoop = DemoLoop,
}
