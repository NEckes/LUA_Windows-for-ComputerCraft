local function redraw()
  term.redirect(conf.startMenu.area)
  term.setCursorPos(1,1)
  term.setBackgroundColor(conf.startMenu.col)
  term.clear()
  end
function open()
  win.pause()
  conf.startMenu.area.setVisible(true)
  local x,y = conf.startMenu.area.getPosition()
  local w,h = conf.startMenu.area.getSize()
  while true do
    local e = {os.pullEvent()}
    if ({mouse_click=1,mouse_drag=1,mouse_scroll=1,monitor_touch=1})[e[1]]==1 then
      cclite.message("OK")
      if e[3]>=x and e[3]<x+w and e[4]>=y and e[4]<y+h then
        
        else
        close()
        win.resume()
        if not (e[4]==({conf.taskBar.area.getPosition()})[2] and e[3]<=#conf.taskBar.startBtn.text+2) then os.queueEvent(unpack(e)) end
        break
        end
      end
    if e[1]=="key" or e[1]=="char" then
      
      end
    end
  end
function close()
  conf.startMenu.area.setVisible(false)
  win.redraw()
  end
redraw()