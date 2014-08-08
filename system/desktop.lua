spriteW, spriteH = 6,3
path = "/TEST"
positions = {}
function draw()
  term.redirect(conf.desktop.area)
  if path~=nil then paintutils.drawImage(paintutils.loadImage(path),1,1) end
  for i,j in pairs(positions) do
    for k,l in pairs(j) do
      paintutils.drawImage(paintutils.loadImage(l),(i-1)*spriteW+1+spriteW/2-1,k)
      end
    end
  end