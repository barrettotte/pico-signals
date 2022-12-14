pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- pICO sIGNALS
-- bARRETT oTTE. 2022

function _init()
  is_playing = false

  sig = {
    freq = 6,
    amp = 12,
    offset = 56,
    sample = 127
  }
  settings = {
    "freq",
    "amp",
    "offset",
    "sample"
  }
  waveforms = {
    "sine",
    "square",
    "triangle",
    "sawtooth"
    -- "off"
  }
  setting = 0
  waveform = 0
  last = time()
end

function _update()

  -- title screen
  if not is_playing then
    if btnp(❎) then
      is_playing = true
    end
    return
  end

  local s = settings[setting + 1]

  if btnp(❎) and (time() - last) > 0.25 then
    waveform += 1
    if waveform >= #waveforms then
      waveform = 0
    end
    last = time()
  end

  if (time() - last) < 0.05 then
    return -- debounce
  end

  if btn(➡️) then
    sig[s] = min(sig[s]+1, 255)
    last = time()
  end

  if btn(⬅️) then
    sig[s] -= 1
    if setting ~= 3 then
      sig[s] = max(sig[s], 0)
    end
    last = time()
  end

  if btnp(⬆️) then
    setting -= 1
    last = time()
  end

  if btnp(⬇️) then
    setting += 1
    last = time()
  end

  setting %= #settings
end

function _draw()
  cls()
  print("pICO sIGNALS", 40, 0, 11)

  -- draw title screen
  if not is_playing then
    print("bARRETT oTTE", 40, 20, 11)
    print("pico-1K jAM 2022", 32, 30, 11)
    print(" ❎  - change wave", 26, 60, 7)
    print("⬅️➡️ - change value", 26, 70, 7)
    print("⬆️⬇️ - navigate menu", 26, 80, 7)
    print("press ❎ to start", 32, 100, 11)
    return
  end

  -- axes
  line(63, 10, 63, 105, 1)
  line(0, 56, 127, 56, 1)

  -- print waveform
  print(waveforms[waveform+1], 3, 13, 7)

  draw_signal()

  -- border
  rectfill(0, 10, 127, 8, 0)
  line(0, 9, 127, 9, 7)
  line(0, 104, 127, 104, 7)
  line(0, 10, 0, 104, 7)
  line(127, 10, 127, 104, 7)
  rectfill(0, 105, 127, 127, 0)

  draw_menu()
end

function draw_signal()
  local p = 128 / sig.freq
  local dx = 128 / sig.sample

  for x=0,128,dx do
    if waveform == 0 then
      line(x, sig_sine(x,p), x+dx, sig_sine(x+dx,p), 11)
    elseif waveform == 1 then
      line(x, sig_square(x,p), x+dx, sig_square(x+dx,p), 11)
    elseif waveform == 2 then
      line(x, sig_triangle(x,p), x+dx, sig_triangle(x+dx,p), 11)
    elseif waveform == 3 then
      line(x, sig_saw(x,p), x+dx, sig_saw(x+dx,p), 11)
    else
      line(x, sig.offset, x+dx, sig.offset, 11)
    end
  end
end

function sig_sine(t,p)
  return ceil(sig.amp * sin(t/p) + sig.offset)
end

function sig_square(t,p)
  return sig.amp * sgn(sin(t/p)) + sig.offset
end

function sig_triangle(t,p)
  return sig.amp * (2*abs(2*((t/p)-flr((t/p)+(1/2))))-1) + sig.offset
end

function sig_saw(t,p)
  return sig.amp * ((t/p)-flr((1/2)+(t/p))) + sig.offset
end

function draw_menu()
  local x = 8
  local y = 107

  for i=1,#settings do
    local s = settings[i]
    local v = sig[s]

    if i == 3 then
      v = 128-v-72 -- zero adjust offset value
    end

    -- show selected menu entry
    local c = 7
    if s == settings[setting + 1] then
      c = 11
    end

    -- next column of menu
    if i == 3 then
      x += 68
      y = 107
    end

    print(s.."="..v, x+3, y+3, c)
    y += 10
  end
end
