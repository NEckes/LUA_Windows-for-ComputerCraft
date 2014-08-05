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
win = window.create(term.current(),1,1,w,h-1)
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
  area = window.create(term.current(),1,3,19,h-3,false),
  col = colors.yellow
  }