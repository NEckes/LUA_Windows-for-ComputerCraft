local Bpause = false
local function IDbyPID(PID)
  for i,j in pairs(obj) do
    if j.PID==PID then return i end
    end
  end
local function getLocation(screen)
  local x,y = screen.getPosition()
  local w,h = screen.getSize()
  return x,y,w,h
  end
local function drawFrame(ID)
  local term = obj[ID].frame
  local w,h = term.getSize()
  term.setCursorPos(1,1) term.setBackgroundColor(colors.black) term.clear() --clear
  term.setTextColor(conf.frame.textCol) if order[1]==ID then term.setBackgroundColor(conf.frame.activeCol) else term.setBackgroundColor(conf.frame.inactiveCol) end
  term.write(string.rep(" ",w))
  term.setCursorPos(2,1)
  if #obj[ID].title>w-5 then
    term.write(string.sub(obj[ID].title,1,w-7).."..")
    else
    term.write(obj[ID].title)
    end
  term.setCursorPos(w-2,1)
  if obj[ID].btn[1]==1 then term.write(conf.frame.btn.minBtn[1]) else term.write(" ") end
  if obj[ID].btn[2]==1 then if obj[ID].ws>0 then term.write(conf.frame.btn.wsBtn[obj[ID].ws]) end else term.write(" ") end
  if obj[ID].btn[3]==1 then term.setBackgroundColor(conf.frame.btn.closeBtn[2]) term.write(conf.frame.btn.closeBtn[1]) end
  
  term.setBackgroundColor(conf.frame.sides)
  for i=2,h-1 do
    term.setCursorPos(1,i) term.write(" ")
    term.setCursorPos(w,i) term.write(" ")
    end
  term.setCursorPos(1,h)
  term.setBackgroundColor(conf.frame.corners[2])
  term.write(" ")
  term.setBackgroundColor(conf.frame.sides)
  term.write(string.rep(" ",w-2))
  term.setBackgroundColor(conf.frame.corners[2])
  term.write(" ")
  end
local function draw()
  nativeterm.setBackgroundColor(colors.black)
  nativeterm.clear()
  for i=#order,1,-1 do
    obj[order[i]].frame.redraw()
    obj[order[i]].window.redraw()
    end
  end
local function onTerminate(PID)
  remove(IDbyPID(PID))
  end
local function createHandle(ID)
  local handle = {}
  handle.ID = ID
  handle.modify = function(key,value) obj[handle.ID][key] = value end
  handle.value = function(key) return obj[handle.ID][key] end
  handle.remove = function() remove(handle.ID) end
  handle.setVisible = function(state) setVisible(handle.ID,state) end
  handle.setPos = function(x,y,w,h) setPos(handle.ID,x,y,w,h) end
  handle.setWindowState = function(ws) setWindowState(handle.ID,ws) end
  handle.setFocus = function() setOrder(handle.ID,1) end
  handle.setButtons = function(min,max,close) setButtons(handle.ID,min,max,close) end
  handle.setTitle = function(title) setTitle(handle.ID,title) end
  return handle
  end
local function frame_click(ID,e)
  local data = obj[ID]
  local x,y,w,h = getLocation(data.frame)
  if e[1]=="mouse_click" or e[1]=="monitor_touch" then
    e[3] = e[3]-x+1
    e[4] = e[4]-y+1
    if e[4]==1 then
      if e[3]==w and data.btn[3]==1 then -- [X]
        remove(ID)
        return
        end
      if e[3]==w-1 and data.btn[2]==1 then -- [O]
        if data.ws==0 then return end
        setWindowState(ID,math.abs(data.ws-3))
        return
        end
      if e[3]==w-2 and data.btn[1]==1 then -- [_]
        setWindowState(ID,0)
        return
        end
      if data.canMove then
        data.save.oldX = e[3]-1
        dragFunc = function(_x,_y) setPos(data.ID,_x-data.save.oldX,_y) end
        return
        end
      end
    if not data.canResize then return end
    if e[4]==h then
      if e[3]==1 then dragFunc = function(_x,_y) setPos(ID,_x,y,w-(_x-x),_y-y+1) end
      elseif e[3]==w then dragFunc = function(_x,_y) setPos(ID,x,y,_x-x+1,_y-y+1) end
      else dragFunc = function(_x,_y) setPos(ID,x,y,w,_y-y+1) end end
      return
      end
    if e[3]==1 then dragFunc = function(_x,_y) setPos(ID,_x,y,w-(_x-x),h) end return end
    if e[3]==w then dragFunc = function(_x,_y) setPos(ID,x,y,_x-x+1,h) end return end
    end
  end
local function check_hitbox(ID,e)
  local data = obj[ID]
  local x,y,w,h = getLocation(data.frame)
  if e[1]=="mouse_drag" then
    if dragFunc~=nil then
      dragFunc(e[3],e[4])
      return false
      end
    end
  if data.visible and e[3]>=x+1 and e[3]<x+w-1 and e[4]>=y+1 and e[4]<y+h-1 then
    e[3] = e[3]-x
    e[4] = e[4]-y
    setOrder(ID,1)
    return e
    end
  if data.visible and e[3]>=x and e[3]<x+w and e[4]>=y and e[4]<y+h then
    setOrder(ID,1)
    frame_click(ID,e)
    return false
    end
  return nil
  end
local function onError(PID,err)
  printError("PID "..PID.." crashed! "..err)
  end
local function order_remove(ID)
  for i,j in pairs(order) do if j==ID then table.remove(order,i) if i==1 and #order>0 then drawFrame(order[1]) end break end end
  if #order==0 then nativeterm.setCursorBlink(false) end
  draw()
  end
local function order_add(ID,pos)
  table.insert(order,pos,ID)
  if pos==1 then drawFrame(ID) if order[2]~=nil then drawFrame(order[2]) end end
  draw()
  end

function redraw() -- external only
  draw()
  end
function create(x,y,w,h,title,func)
  local data = {}
  data.ID = #obj+1
  data.ws = 1
  data.visible = false
  data.canResize = true
  data.canMove = true
  data.frame = window.create(conf.win,x,y,w,h,false)
  data.window = window.create(data.frame,2,2,w-2,h-2,true)
  data.title = title
  data.PID = process.create(func,{onTerminate = onTerminate, onError = onError, screen = data.window, type = "WINDOW"})
  data.save = {orderPos = 1}
  data.btn = {1,1,1}
  table.insert(obj,data)
  return createHandle(data.ID)
  end
function setWindowState(ID,ws)
  local data = obj[ID]
  data.save.ws = data.ws
  data.ws = ws
  if ws==0 then
    setVisible(ID,false)
    data.tab = taskbar.addTab(data.title,function() data.ws=data.save.ws setVisible(ID,true) end)
    end
  if ws==1 then
    data.canResize = data.save.canResize
    data.canMove = data.save.canMove
    setPos(ID,data.save.x,data.save.y,data.save.w,data.save.h)
    end
  if ws==2 then
    local x,y,w,h = getLocation(data.frame)
    data.save.x = x
    data.save.y = y
    data.save.w = w
    data.save.h = h
    data.save.canResize = data.canResize
    data.save.canMove = data.canMove
    data.canResize = false
    data.canMove = false
    setPos(ID,1,1,({nativeterm.getSize()})[1],({nativeterm.getSize()})[2])
    end
  end
function remove(ID)
  process.terminate(obj[ID].PID)
  obj[ID].frame.setVisible(false)
  obj[ID] = nil
  order_remove(ID)
  if #order == 0 then nativeterm.setCursorBlink(false) end
  end
function setVisible(ID,state)
  obj[ID].visible = state
  obj[ID].frame.setVisible(state)
  if state==false then
    for i,j in pairs(order) do if j==ID then obj[ID].save.orderPos = i break end end
    order_remove(ID)
    else
    if obj[ID].save.orderPos>#order then obj[ID].save.orderPos = #order+1 end
    order_add(ID,obj[ID].save.orderPos)
    end
  end
function setPos(ID,x,y,w,h)
  local data = obj[ID]
  if w==nil then w = ({data.frame.getSize()})[1] end
  if h==nil then h = ({data.frame.getSize()})[2] end
  local currW,currH = data.frame.getSize()
  data.frame.clear()
  data.frame.reposition(x,y,w,h)
  data.window.reposition(2,2,w-2,h-2)
  drawFrame(ID)
  draw()
  if (w~=nil and w~=currW) or (h~=nil and h~=currH) then os.queueEvent("window_resize",ID) end
  end
function setOrder(ID,pos)
  local old = order[1]
  table.insert(order,pos,ID)
  for i=1,#order do
    if order[i]==ID and i~=pos then table.remove(order,i) if i==1 then drawFrame(order[1]) end break end
    end
  if pos==1 then
    drawFrame(order[1])
    drawFrame(old)
    end
  draw()
  end
function editTitle(ID,title)
  obj[ID].title = title
  drawFrame(ID)
  end
function setButtons(ID,btn1,btn2,btn3)
  local data = obj[ID]
  if btn1 then data.btn[1] = btn1 end
  if btn2 then data.btn[2] = btn2 end
  if btn3 then data.btn[3] = btn3 end
  drawFrame(ID)
  end
function pause()
  Bpause = true
  end
function resume()
  Bpause = false
  end

process.insert_processEvent(function(e)
  local arr = {}
  for i,j in pairs(process.p) do if j.type~="WINDOW" and e[1]~="terminate" then table.insert(arr,i,e) end end
  if #obj == 0 or Bpause==true then return arr end
  if ({key=1,char=1,terminate=1})[e[1]]==1 and order[1]~=nil then
    table.insert(arr,obj[order[1]].PID,e)
  elseif ({mouse_click=1,monitor_touch=1,mouse_scroll=1,mouse_drag=1})[e[1]]==1 then
    if e[1]~="mouse_drag" then dragFunc = nil end
    for i=1,#order do
      local modE = check_hitbox(order[i],e)
      if modE~=nil then if modE~=false then table.insert(arr,obj[order[i]].PID,modE) end break end
      end
  elseif e[1]=="window_resize" then table.insert(arr,obj[order[1]].PID,{"term_resize"})
    else for i,j in pairs(process.p) do if j.type=="WINDOW" then table.insert(arr,i,e) end end end
  return arr
  end)

nativeterm = conf.win
obj = {} order = {}