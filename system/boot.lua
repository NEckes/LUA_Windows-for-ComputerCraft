local function loadFile(Fname)
  local tEnv = {}
  setmetatable( tEnv, { __index = _G } )
  local fnAPI, err = loadfile( Fname )
  if fnAPI then
    setfenv( fnAPI, tEnv )
    fnAPI()
    else
    printError( err )
    return false
    end
  local tAPI = {}
  for k,v in pairs( tEnv ) do
    tAPI[k] =  v
    end
  _G[fs.getName(string.sub(Fname,1,#Fname-4))] = tAPI  
  end

shell.run("clear")
loadFile("conf/conf.lua")
loadFile("conf/favorites.dat")
loadFile("system/process.lua")
loadFile("system/taskbar.lua")
loadFile("system/startMenu.lua")
loadFile("system/win.lua")
loadFile("system/desktop.lua")
loadFile("system/logon.lua")
taskbar.start()
desktop.draw()
startMenu.redraw()
state,err = pcall(process.start)
cclite.message(tostring(err))