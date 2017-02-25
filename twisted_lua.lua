require "moonscript" -- for color module
local DemoLoop = require("demoloop_lua").DemoLoop
local hsl2rgb  = require("schedulor.color").hsl2rgb

local TwistedLua = setmetatable({}, DemoLoop)
TwistedLua.__index = TwistedLua

function TwistedLua.new()
  local self = setmetatable(DemoLoop.new(), TwistedLua)

  love.math.setRandomSeed(21)
  self.background = { hsl2rgb(love.math.random(), love.math.random()/3+.2, love.math.random()/4) }
  love.graphics.setBackgroundColor(self.background)
  hue = love.math.random()

  self.shades = setmetatable({}, {
    __index = function (shades, key)
      local val = { hsl2rgb(hue, .7, key * .3 + .1) }
      rawset(shades, key, val)
      return val
    end
  })

  self.length = math.pi*4

  return self
end

function TwistedLua:draw()
  width, height = love.graphics.getDimensions()
  love.graphics.translate(width/2, height/2 + 70)

  function draw(i)
    love.graphics.push()
    love.graphics.translate(0, -120*i)
    love.graphics.scale(1, 0.5)
    love.graphics.scale(1 - 0.1 * math.sin(self.time + i*2))
    love.graphics.scale(0.8 - i * .4 * math.cos(self.time))
    love.graphics.rotate(self.time/4)
    love.graphics.rotate(i * .6 * math.cos(self.time))
    love.graphics.setColor(self.shades[i])
    love.graphics.rectangle("fill", -80, -80, 160, 160)
    love.graphics.pop()
  end

  for i=0,1,1/(20 + 19 * math.sin(self.time / 2)) do
    draw(i)
  end
  draw(1)
end

return TwistedLua
