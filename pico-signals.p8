pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
function _init()
  r,x,y,z=0 l=time()
  s={freq=6,amp=12,offset=56,sample=127}
  a={"freq","amp","offset","sample"} b=0
  c={"sine","square","triangle","sawtooth"} d=0
end
function _update()
  if r==0 then if btnp(❎)then r=1 end return end x=a[b+1]
  if btnp(❎) and (time()-l)>0.25 then d+=1 if d>=#c then d=0 end l=time()end
  if(time()-l)<0.05 then return end
  if btn(➡️)then s[x]=min(s[x]+1,255) l=time()end
  if btn(⬅️)then s[x]-=1 if b~=3 then s[x]=max(s[x],0)end l=time()end
  if btnp(⬆️)then b-=1 l=time()end
  if btnp(⬇️)then b+=1 l=time()end
  b%=#a
end
function _draw()
  cls()
  print("pICO sIGNALS",40,0,11)
  if r==0 then
    print("bARRETT oTTE",40,20)
    print("pico-1K jAM 2022",32,30)
    print(" ❎  - change wave",26,60,7)
    print("⬅️➡️ - change value",26,70)
    print("⬆️⬇️ - navigate menu",26,80)
    print("press ❎ to start",32,100,11)
    return
  end
  line(63,10,63,105,1)
  line(0,56,127,56)
  print(c[d+1],3,13,7)
  y=128/s.freq z=128/s.sample
  for x=0,128,z do
    if d==0 then line(x,s1(x,y),x+z,s1(x+z,y),11)
    elseif d==1 then line(x,s2(x,y),x+z,s2(x+z,y),11)
    elseif d==2 then line(x,s3(x,y),x+z,s3(x+z,y),11)
    else line(x,s4(x,y),x+z,s4(x+z,y),11)end
  end
  rectfill(0,10,127,8,0)
  line(0,9,127,9,7)
  line(0,104,127,104)
  line(0,10,0,104)
  line(127,10,127,104)
  rectfill(0,105,127,127,0)
  x=8 y=107
  for i=1,#a do
    z=s[a[i]]if i==3 then x+=68 y=107 z=128-s[a[i]]-72 end
    print(a[i].."="..z,x+3,y+3,a[i]==a[b+1]and 11 or 7)
    y+=10
  end
end
function sw(i)return s.amp*i+s.offset end
function s1(t,p)return ceil(sw(sin(t/p)))end
function s2(t,p)return sw(sgn(sin(t/p)))end
function s3(t,p)return sw(2*abs(2*((t/p)-flr((t/p)+0.5)))-1)end
function s4(t,p)return sw((t/p)-flr(0.5+(t/p)))end