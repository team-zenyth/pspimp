local fond = Image.load("splash/fond.jpg")
local t = 250
local masque = Image.createEmpty(480,272)
masque:clear(Color.new(0,0,0,t))
while t >= 0 do
 masque = Image.createEmpty(480,272)
 masque:clear(Color.new(0,0,0,t))
 screen:blit(0,0,fond)
 screen:blit(0,0,masque)
 screen.flip()
 screen.waitVblankStart()
 t = t-15
end
local space = Image.load("splash/mascotte.png")
local team = Image.load("splash/titre.png")
local x = 480
while x >= 0 do
 screen:blit(0,0,fond)
 screen:blit(x,0,space)
 screen:blit(-x,0,team)
 screen.flip()
 x = x-4
 screen.waitVblankStart()
end

fond:blit(0,0,space)
fond:blit(0,0,team)
local t = 0
local masque = Image.createEmpty(480,272)
masque:clear(Color.new(0,0,0,t))
while t ~= 255 do
 masque = Image.createEmpty(480,272)
 masque:clear(Color.new(0,0,0,t))
 screen:blit(0,0,fond)
 screen:blit(0,0,masque)
 screen.flip()
 screen.waitVblankStart()
 t = t+15
end

dofile("pspimp.lua")
