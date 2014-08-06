local function event(x,y)
  local data = conf.startMenu.elements[({conf.startMenu.area.getSize()})[2]-y+1]
  if data~=nil then return data[2] end
  end

function redraw()
  term.redirect(conf.startMenu.area)
  term.setTextColor(conf.startMenu.body.textCol)
  term.setBackgroundColor(conf.startMenu.body.col)
  term.clear()
  for i=1,#conf.startMenu.elements do
    term.setCursorPos(1,({term.getSize()})[2]-i+1)
    write(conf.startMenu.elements[i][1])
    end
  term.setCursorPos(2,1)
  term.setTextColor(conf.startMenu.head.textCol)
  term.setBackgroundColor(conf.startMenu.head.col)
  term.clearLine()
  write(logon.currUser)
  end
function open()
  win.pause()
  conf.startMenu.area.setVisible(true)
  local x,y = conf.startMenu.area.getPosition()
  local w,h = conf.startMenu.area.getSize()
  local func
  while true do
    local e = {os.pullEvent()}
    if ({mouse_click=1,mouse_drag=1,mouse_scroll=1,monitor_touch=1})[e[1]]==1 then
      cclite.message("OK")
      if e[3]>=x and e[3]<x+w and e[4]>=y and e[4]<y+h then
        func = event(e[3]-x+1,e[4]-y+1)
        if func~=nil then close() break end
        else
        close()
        if not (e[4]==({conf.taskBar.area.getPosition()})[2] and e[3]<=#conf.taskBar.startBtn.text+2) then os.queueEvent(unpack(e)) end
        break
        end
      end
    if e[1]=="key" or e[1]=="char" then
      
      end
    end
  if func~=nil then func() end
  end
function close()
  conf.startMenu.area.setVisible(false)
  win.resume()
  win.redraw()
  end