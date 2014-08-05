local function draw()
  term.redirect(conf.taskBar.area)
  term.setCursorPos(1,1)
  term.setCursorBlink(false)
  term.setTextColor(conf.taskBar.textCol)
  term.setBackgroundColor(conf.taskBar.startBtn.col)
  write(" "..conf.taskBar.startBtn.text.." ")
  term.setBackgroundColor(conf.taskBar.col)
  write(string.rep(" ",({term.getSize()})[1]-#conf.taskBar.startBtn.text-2))
  term.setCursorPos(#conf.taskBar.startBtn.text+3,1)
  for i,j in pairs(order) do
    write(" "..tabs[j].text.." ")
    end
  end
local function openTab(ID)
  tabs[ID].func()
  end
local function main()
  while true do
    ::START::
    local e = {os.pullEvent()}
    if e[4]~=({conf.taskBar.area.getPosition()})[2] then goto START end
    if (e[1]=="mouse_click" and e[2]==1) or e[1]=="monitor_touch" then
      if e[3]<=#conf.taskBar.startBtn.text+2 then
        cclite.message("START")
        else
        local pos = #conf.taskBar.startBtn.text+3
        for i,j in pairs(order) do
          if e[3]>=pos and e[3]<pos+#tabs[j].text+2 then
            openTab(j)
            remove(j)
            break
            end
          pos = pos + #tabs[j].text+2
          end
        end
      end
    end
  end
local function createHandle(ID)
  local handle = {}
  handle.setText = function(text) setText(ID,text) end
  handle.setOrder = function(pos) setOrder(ID,pos) end
  handle.remove = function() remove(ID) end
  return handle
  end
local function onError(PID,err)
  term.setCursorPos(1,1) error(err)
  end
function remove(ID)
  tabs[ID] = nil
  for i,j in pairs(order) do if j==ID then table.remove(order,i) break end end
  draw()
  end
function start()
  process.create(main,{screen = conf.taskBar.area, onError = onError})
  draw()
  end
function setText(ID,text)
  tabs[ID].text = text
  draw()
  end
function setOrder(ID,pos)
  table.insert(order,pos,ID)
  for i,j in pairs(order) do if j==ID and i~=pos then table.remove(order,i) break end end
  draw()
  end
function addTab(text,func)
  local data = {}
  data.text = text
  data.ID = #tabs+1
  data.func = func
  table.insert(tabs,data)
  table.insert(order,data.ID)
  draw()
  return createHandle(data.ID)
  end

tabs = {} order = {}