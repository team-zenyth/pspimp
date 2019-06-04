--  ______________________  --
--/|----------------------|\--
--||*~Made by Psgarsenal~*||--
--||*   Or   Kilian  ,   *||--
--||* if  U  know  me :p *||--
--||*~~~~~~~~~~~~~~~~~~~~*||--
--||*~blog.bendermix.org~*||--
--\|______________________|/--
--  ----------------------  --

noir = Color.new(0,0,0)
blanc = Color.new(255,255,255)
ouvert = false
pp = noir
ap = blanc

font = Font.load("Verdana.ttf")
font:setPixelSizes(16,16)

-- icones outils

icones_outils = {crayon = Image.load("crayon.png"),
                 police = Image.load("police.png"),
                 pipette = Image.load("pipette.png"),
                 negatif = Image.load("negatif.png"),
                 assombrir = Image.load("assombrir.png"),
                 gris = Image.load("gris.png"),
                 eclaircir = Image.load("eclaircir.png"),
                 enregistrer = Image.load("disquette.png"),
                 ouvrir = Image.load("dossier.png"),
                 nouveau = Image.load("nouveau.png")}

outil_selectionne = 1 -- 1 = crayon/2 = police/3 = pipette

-- interface

image = Image.createEmpty(1,1)
couleur = Image.load("couleur.png")
inverser = Image.load("inverser.png")
saturation = Image.load("saturation.png")
selecteur = Image.load("selecteur.png")
souris = Image.load("curseur.png")
transparence = Image.load("fond.jpg")

fond = Image.createEmpty(480,272)
for y=0,14 do
 for x=0,24 do
  fond:blit(x*20,y*20,transparence)
 end
end

local curseur = {x = 240, y = 136, pic = Image.createEmpty(9,9)}

curseur.pic:pixel(3,3,blanc)
curseur.pic:pixel(5,5,blanc)
curseur.pic:pixel(3,5,blanc)
curseur.pic:pixel(5,3,blanc)

curseur.pic:drawLine(0,4,3,4,noir)
curseur.pic:drawLine(4,0,4,3,noir)
curseur.pic:drawLine(5,4,9,4,noir)
curseur.pic:drawLine(4,5,4,9,noir)


-- ATTENTION: LES PROCHAINES PORTIONS DE CODE EN COMMENTAIRE
-- RALENTISSENT L'EXECUTION DU CODE


function eclaircir(calque)
 local width, height = calque:width(), calque:height()
 local surface = Image.createEmpty(width, height)
 local img_pixel, colors, color = 0, 0, 0
 for i = 1, width do
  for j = 1, height do
--   screen:clear()
--   screen:fillRect(0,0,i/width*480,272,Color.new(50,50,50))
   img_pixel = image:pixel(i-1, j-1)
   colors = img_pixel:colors()
   color = Color.new(colors.r+10, colors.g+10, colors.b+10, colors.a)
   surface:pixel(i-1, j-1, color)
--   screen.flip()
  end
 end
 return surface
end

function assombrir(calque)
 local width, height = calque:width(), calque:height()
 local surface = Image.createEmpty(width, height)
 local img_pixel, colors, color = 0, 0, 0
 for i = 1, width do
  for j = 1, height do
--   screen:clear()
--   screen:fillRect(0,0,i/width*480,272,Color.new(50,50,50))
   img_pixel = image:pixel(i-1, j-1)
   colors = img_pixel:colors()
   color = Color.new(colors.r-10, colors.g-10, colors.b-10, colors.a)
   surface:pixel(i-1, j-1, color)
--   screen.flip()
  end
 end
 return surface
end

function negatif(calque)
 local width, height = calque:width(), calque:height()
 local surface = Image.createEmpty(width, height)
 local img_pixel, colors, color = 0, 0, 0
 for i = 1, width do
  for j = 1, height do
--   screen:clear()
--   screen:fillRect(0,0,i/width*480,272,Color.new(50,50,50))
   img_pixel = calque:pixel(i-1, j-1)
   colors = img_pixel:colors()
   color = Color.new(255-colors.r, 255-colors.g, 255-colors.b, colors.a)
   surface:pixel(i-1, j-1, color)
--   screen.flip()
  end
 end
 return surface
end

function gris(calque)
 local width, height = calque:width(), calque:height()
 local surface = Image.createEmpty(width, height)
 local img_pixel, colors, color = 0, 0, 0
 for i = 1, width do
  for j = 1, height do
--   screen:clear()
--   screen:fillRect(0,0,i/width*480,272,Color.new(50,50,50))
   img_pixel = image:pixel(i-1, j-1)
   colors = img_pixel:colors()
   colors_gris = (colors.r + colors.g + colors.b) /3
   color = Color.new(colors_gris, colors_gris, colors_gris, colors.a)
   surface:pixel(i-1, j-1, color)
--   screen.flip()
  end
 end
 return surface
end

function Newcolor(rvba)
 ok = false
 selection = 0
 pointeur = {x=0,y=0}
 while not ok do
  pad = Controls.read()
  screen:clear(Color.new(222,197,180))
  if math.abs(pad:analogY()) > 10 then
   pointeur.y = pointeur.y + pad:analogY() / 60
  end
  if math.abs(pad:analogX()) > 10 then
   pointeur.x = pointeur.x + pad:analogX() / 60
  end
  if pointeur.x < 0 then pointeur.x = 0 end
  if pointeur.x > 254 then pointeur.x = 254 end
  if pointeur.y < 0 then pointeur.y = 0 end
  if pointeur.y > 254 then pointeur.y = 254 end
  teinte = couleur:pixel(1,selection)
  screen:blit(10,10,couleur)
  screen:blit(7,8+selection,selecteur)
  screen:fillRect(30,10,255,255,teinte)
  screen:blit(30,10,saturation)
  screen:blit(pointeur.x+26,pointeur.y+6,curseur.pic)
  if pad:down() and selection < 254 then
   selection = selection +1
  end
  if pad:up() and selection > 0 then
   selection = selection -1
  end
  if pad:start() then
   ok = true
   rvba = screen:pixel(pointeur.x+30,pointeur.y+10)
  end
  screen:flip()
  screen.waitVblankStart()
  oldpad = pad
 end
 return rvba
end

-- EXPLORATEUR DE FICHIERS

function ouvrir()
choisis = false
Partie = 1
Select = 1
PosY = 30
PosYDep = 30
PosX = 10
System.currentDirectory("ms0:/")
Fichiers = System.listDirectory()
while not choisis do
pad = Controls.read()
screen:clear(Color.new(222,197,180))
screen:print(10,12,System.currentDirectory().."/")
for i = Partie, Partie + 31 - 1 do
 extension = string.upper(string.sub(Fichiers[i].name,-3))
 if extension == "PNG" or extension == "JPG" then screen:print(PosX,PosY,Fichiers[i].name,Color.new(255,0,0))
 elseif Fichiers[i].directory then screen:print(PosX,PosY,Fichiers[i].name)
 else screen:print(PosX,PosY,Fichiers[i].name,Color.new(100,100,100)) end
 PosY = PosY + 9
 if table.getn(Fichiers) == i then break end
end
PosY = PosYDep
screen:print(0,(Select-Partie)*9+PosYDep,">")
if pad:down() and not oldpad:down() then Select = Select + 1 end
if pad:up() and not oldpad:up() then Select = Select - 1 end
if pad:right() and not oldpad:right() then Select = Select + 31 / 2 end
if pad:left() and not oldpad:left() then Select = Select - 31 / 2 end
if Select < 1 and 1 > table.getn(Fichiers) then Select = table.getn(Fichiers) end
if Select > Partie + 31 - 1 and Partie + 31 - 1 ~= table.getn(Fichiers) then Partie = Partie + 31 elseif Select < Partie then Partie = Partie - 31 end
if pad:cross() and not oldpad:cross() then
 if Fichiers[Select].directory then
  System.currentDirectory(Fichiers[Select].name)
  Fichiers = System.listDirectory()
  Partie = 1
  Select = 1
 else
  extension = string.upper(string.sub(Fichiers[Select].name,-3))
  if extension == "PNG" or extension == "JPG" then
   image_choisie = Image.load(Fichiers[Select].name)
   choisis = true
  end
 end
end
if pad:triangle() and not oldpad:triangle() then
 Select,Partie = 1,1
 if System.currentDirectory() ~= "ms0:/" then System.currentDirectory("..") end
 Fichiers = System.listDirectory()
end
screen:flip()
screen.waitVblankStart()
oldpad = pad
end
emplacement = System.currentDirectory().."/"..Fichiers[Select].name
return image_choisie
end

-- FIN

-- NOUVELLE IMAGE

function Nouveau()
 ok = false
 taille = {x=100,y=100}
 while not ok do
  pad = Controls.read()
  screen:clear(Color.new(222,197,180))

  screen:print(10,10,"Hauteur:"..taille.y)
  screen:print(10,20,"^|v")
  screen:print(10,30,"Largeur:"..taille.x)
  screen:print(10,40,"<|>")

  if taille.x <= 0 then taille.x = 1 end
  if taille.y <= 0 then taille.y = 1 end

  if pad:r() then
   if pad:right() and not oldpad:right() then taille.x = taille.x + 1 end
   if pad:left() and not oldpad:left() then taille.x = taille.x - 1 end
   if pad:down() and not oldpad:down() then taille.y = taille.y + 1 end
   if pad:up() and not oldpad:up() then taille.y = taille.y - 1 end
  else
   if pad:right() then taille.x = taille.x + 2 end
   if pad:left() then taille.x = taille.x - 2 end
   if pad:down() then taille.y = taille.y + 2 end
   if pad:up() then taille.y = taille.y - 2 end
  end

  if pad:start() then
   ok = true
   img = Image.createEmpty(taille.x,taille.y)
  end

  screen:flip()
  screen.waitVblankStart()
  oldpad = pad
 end
 return img
end

-- FIN

System.message("r pour ralentir le curseur.",2)

while true do
screen:blit(0,0,fond)

pad = Controls.read()

if pad:r() then
 if math.abs(pad:analogY()) > 10 then
  curseur.y = curseur.y + pad:analogY() / 60
 end
 if math.abs(pad:analogX()) > 10 then
  curseur.x = curseur.x + pad:analogX() / 60
 end
 if pad:left() then
  curseur.x = curseur.x - 1
 end
 if pad:up() then
  curseur.y = curseur.y - 1
 end
 if pad:right() then
  curseur.x = curseur.x + 1
 end
 if pad:down() then
  curseur.y = curseur.y + 1
 end
else
 if math.abs(pad:analogY()) > 10 then
  curseur.y = curseur.y + pad:analogY() / 15
 end
 if math.abs(pad:analogX()) > 10 then
  curseur.x = curseur.x + pad:analogX() / 15
 end
 if pad:left() then
  curseur.x = curseur.x - 2
 end
 if pad:up() then
  curseur.y = curseur.y - 2
 end
 if pad:right() then
  curseur.x = curseur.x + 2
 end
 if pad:down() then
  curseur.y = curseur.y + 2
 end
end

if curseur.x > 479 then
 curseur.x = 479
elseif curseur.x < 0 then
 curseur.x = 0
end
if curseur.y > 271 then
 curseur.y = 271
elseif curseur.y < 0 then
 curseur.y = 0
end

 screen:blit(0,0,image)

if menu == true then
 screen:drawLine(380,0,380,272,Color.new(50,50,50))
 screen:fillRect(381,0,99,272,Color.new(20,20,20))
 screen:fillRect(400,20,20,20,Color.new(0,0,0))
 screen:fillRect(401,21,18,18,ap)
 screen:fillRect(390,10,20,20,Color.new(0,0,0))
 screen:fillRect(391,11,18,18,pp)
 screen:blit(409,10,inverser)
 -- outils
 screen:blit(399,45,icones_outils.police)
 screen:blit(424,45,icones_outils.crayon)
 screen:blit(449,45,icones_outils.pipette)
 screen:blit(399,65,icones_outils.negatif)
 screen:blit(424,65,icones_outils.assombrir)
 screen:blit(449,65,icones_outils.eclaircir)
 screen:blit(399,85,icones_outils.gris)
 -- fichier
 screen:blit(399,251,icones_outils.nouveau)
 screen:blit(424,251,icones_outils.ouvrir)
 screen:blit(449,251,icones_outils.enregistrer)
 
 screen:blit(curseur.x,curseur.y,souris)
 if pad:cross() and not oldpad:cross() then
  if 409 < curseur.x and curseur.x < 420 and 10 < curseur.y and curseur.y < 21 then
   local temp = pp
   pp = ap
   ap = temp
   temp = nil
  end
  if 391 < curseur.x and curseur.x < 419 and 11 < curseur.y and curseur.y < 29 then pp = Newcolor(pp) end
  if 449 < curseur.x and curseur.x < 469 and 45 < curseur.y and curseur.y < 65 then outil_selectionne = 2 end--pipette
  if 424 < curseur.x and curseur.x < 444 and 45 < curseur.y and curseur.y < 65 then outil_selectionne = 1 end--crayon
  if 399 < curseur.x and curseur.x < 419 and 45 < curseur.y and curseur.y < 65 then outil_selectionne = 3 end--police
  if 449 < curseur.x and curseur.x < 469 and 65 < curseur.y and curseur.y < 85 then image = eclaircir(image) end
  if 424 < curseur.x and curseur.x < 444 and 65 < curseur.y and curseur.y < 85 then image = assombrir(image) end
  if 399 < curseur.x and curseur.x < 419 and 65 < curseur.y and curseur.y < 85 then image  = negatif(image) end
  if 399 < curseur.x and curseur.x < 419 and 85 < curseur.y and curseur.y < 105 then image  = gris(image) end
-- fichier
  if 449 < curseur.x and curseur.x < 460 and 251 < curseur.y and curseur.y < 262 then
   if ouvert then
    System.message("Voulez vous ecraser le fichier d'origne?", 1)
    if System.buttonPressed(0) == 1 then image:save(emplacement) end-- enregistrer
   else image:save("ms0:/Picture/"..System.startOSK("Nom image","Nom image")..".png")
   end
  end
  if 424 < curseur.x and curseur.x < 435 and 251 < curseur.y and curseur.y < 262 then ouvert = true image = ouvrir() end-- ouvrir
  if 399 < curseur.x and curseur.x < 410 and 251 < curseur.y and curseur.y < 262 then ouvert = false image = Nouveau() end-- nouveau
 end
 if pad:start() and not oldpad:start() then
  menu = false
 end
else
 screen:drawLine(469,0,469,272,Color.new(50,50,50))
 screen:fillRect(470,0,10,272,Color.new(20,20,20))
 screen:print(471,132,"<")
 if curseur.x > image:width()-1 then
  curseur.x = image:width()-1
 elseif curseur.x < 0 then
  curseur.x = 0
 end
 if curseur.y > image:height()-1 then
  curseur.y = image:height()-1
 elseif curseur.y < 0 then
  curseur.y = 0
 end
 screen:blit(curseur.x-4,curseur.y-4,curseur.pic)
 if outil_selectionne == 1 then
  screen:blit(curseur.x+2,curseur.y-13,icones_outils.crayon)
  if pad:cross() then
   image:pixel(curseur.x,curseur.y,pp)
  end
  if pad:circle() then
   image:pixel(curseur.x,curseur.y,ap)
  end
 elseif outil_selectionne == 2 then
  screen:blit(curseur.x+2,curseur.y-13,icones_outils.pipette)
  if pad:cross() then
   pp = image:pixel(curseur.x,curseur.y)
  end
 elseif outil_selectionne == 3 then
  screen:blit(curseur.x+2,curseur.y-13,icones_outils.police)
  if pad:cross() then
   image:fontPrint(font,curseur.x,curseur.y,System.startOSK("Texte","Texte a dessiner"),pp)
  end
 end
 if pad:start() and not oldpad:start() then
   menu = true
 end
end

 screen.flip()
 screen.waitVblankStart()
 oldpad = pad
end
