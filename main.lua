local i, loop = 2
while true do
  local a = arg[i]
  if not a then break end

  flag = a:match "^%-%-(.*)$"
  if flag then
    if flag == "debug" or flag == "render" then
      _G[string.upper(flag)] = true
    else
      _G[flag] = arg[i+1]
      i = i + 1
    end
  elseif a ~= "." then
    loop = a
    for i=i,1,-1 do table.remove(arg, i) end
    break
  end
  i = i + 1
end

if not loop then
  print("ERROR: no loop specified")
  print("usage: love . [--FLAG] [--OPTION VALUE] <loop> ...")
  print("","global options: fps, output, overwrite")
  print("","global flags: debug, render")
  love.event.push "quit"
else
  package.path = "./?/init.lua;" .. package.path
  require "moonscript"
  Loop = require(loop)
  loop = Loop()
  if RENDER then
    loop:render(fps, output, not no_overwrite)
  else
    loop:run()
  end
end
