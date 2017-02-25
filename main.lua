local i, loop = 2
while true do
  local a = arg[i]
  if not a then break end

  local flag = a:match "^%-%-(.*)$"
  if flag then
    if flag == "debug" or flag == "render" then
      _G[string.upper(flag)] = true
    else
      _G[flag] = arg[i+1]
      i = i + 1
    end
  elseif a ~= "." then
    loop = a
    for n=i,1,-1 do table.remove(arg, n) end
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
  local _, Loop = pcall(require, loop)
  if not _ then
    pcall(require, "moonscript")
    _, err = pcall(require, loop)
    if _ then Loop = err end
  end
  if not _ then
    print("ERROR: failed to require loop")
    print("tried to import with lua and moonscript")
    print("", Loop)
    print("", err)
    love.event.push "quit"
    return
  end

  local _
  if Loop.new then
    _, loop = pcall(Loop.new)
  else
    _, loop = pcall(Loop)
  end
  if not _ then
    print("ERROR: failed to instantiate Loop")
    print("implement either .__call or .new")
    print("(or return a function)")
    print("", loop)
    love.event.push "quit"
    return
  end

  if RENDER then
    loop:render(fps, output, not no_overwrite)
  else
    loop:run()
  end
end
