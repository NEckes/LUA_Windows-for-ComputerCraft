local w,h = term.getSize()
frame = {
  activeCol = colors.blue,
  inactiveCol = colors.gray,
  textCol = colors.white,
  corners = {"+",colors.gray},
  sides = colors.lightGray,
  btn = {
    closeBtn = {"X",colors.red},
    wsBtn = {"O","o"},
    minBtn = {"_"}
    }
  }
desktop = {
  area = window.create(term.current(),1,1,w,h-1)
  }
taskBar = {
  area = window.create(term.current(),1,h,w,1),
  col = colors.blue,
    textCol = colors.white,
  startBtn = {
    col = colors.green,
    text = "Start"
    }
  }
startMenu = {
  area = window.create(term.current(),1,3,15,h-3,false),
  head = {textCol = colors.white, col = colors.blue},
  body = {textCol = colors.black, col = colors.lightGray},
  elements = {
    {"Beenden",os.shutdown},
    {"Cmd",function() win.create(1,1,20,10,"Cmd",function() shell.run("shell") end).setVisible(true) end},
    {"Einstellungen",function() end}
    }
  }