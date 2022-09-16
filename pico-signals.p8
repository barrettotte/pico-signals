pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- pICO sIGNALS
-- bARRETT oTTE. 2022

function _init()
  sig = {
    freq = 4,
    amp = 24,
    offset = 55,
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
    "triangle"
  }
  setting = 0
  waveform = 1--0
  last = time()
end

function _update()
  local s = settings[setting + 1]

  if btn(❎) and (time() - last) > 0.25 then
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

  -- axes
  line(63, 10, 63, 105, 1)
  line(0, 55, 127, 55, 1)

  draw_signal()

  -- border
  rectfill(0, 0, 127, 8, 0)
  line(0, 9, 127, 9, 7)
  line(0, 104, 127, 104, 7)
  line(0, 10, 0, 104, 7)
  line(127, 10, 127, 104, 7)
  rectfill(0, 105, 127, 127, 0)

  print("pICO sIGNALS", 40, 0, 7)
	draw_menu()
end

function draw_signal()
  local p = 128 / sig.freq
	local dx = 128 / sig.sample

	for x=0,127,dx do
    if waveform == 0 then
		  line(x, ceil(sig.amp * sin(x/p) + sig.offset), x+dx, ceil(sig.amp * sin((x+dx) / p) + sig.offset), 11)
    elseif waveform == 1 then
      line(x, sig.amp * min(sgn(sin(x/p)),0) + sig.offset, x+dx, sig.amp * min(sgn(sin((x+dx)/p)),0) + sig.offset, 11)
    elseif waveform == 2 then
      -- https://en.wikipedia.org/wiki/Triangle_wave  (use general definition)
      line(x, sig.amp * (1) + sig.offset, x+dx, sig.amp * (1) + sig.offset, 11)
    else
      line(x, sig.amp * sin(x/p) + sig.offset, x+dx, sig.amp * sin((x+dx) / p + sig.offset), 11)
    end
	end
end

function draw_menu()
	local x = 8
	local y = 107

	for i=1,#settings do
		local s = settings[i]
    local v = sig[s]

    if i == 3 then
      v = 128-v-73 -- zero adjust offset value
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