--
--  Author: Hari Sekhon
--  Date: 2026-01-11 21:40:53 -0500 (Sun, 11 Jan 2026)
--
--  vim:ts=4:sts=4:sw=4:et
--
--  https///github.com/HariSekhon/Hammerspoon
--
--  License: see accompanying Hari Sekhon LICENSE file
--
--  If you're using my code you're welcome to connect with me on LinkedIn
--  and optionally send me feedback to help steer this or other code I publish
--
--  https://www.linkedin.com/in/HariSekhon
--
-- ========================================================================== --
--                    T r a n s m i s s i o n   W a t c h e r
-- ========================================================================== --

-- luacheck: globals hs notify quit_transmission

local hotspot_ssids = {
  "iPhone",
  "Android",
  "Hotspot",
}

local on_hotspot = false

local function is_hotspot_wifi()
  local ssid = hs.wifi.currentNetwork()
  if not ssid then
    return false
  end

  for _, name in ipairs(hotspot_ssids) do
    if ssid:find(name) then
      return true
    end
  end

  return false
end

local function is_hotspot_interface()
  local output = hs.execute("route get default 2>/dev/null")
  if not output then
    return false
  end

  return output:find("bridge") or
         output:find("Bluetooth") or
         output:find("iPhone")
end

local function hotspot_check()
  local hotspot = is_hotspot_wifi() or is_hotspot_interface()

  if hotspot and not on_hotspot then
    on_hotspot = true
    quit_transmission()
    hs.notify.new({
      title = "Hotspot detected",
      informativeText = "Transmission quit to protect data usage",
    }):send()
  elseif not hotspot and on_hotspot then
    on_hotspot = false
  end
end

print "Starting Transmission Network Hotspot Watcher"
local reachability = hs.network.reachability.internet()
reachability:setCallback(hotspot_check)
reachability:start()

-- run once at load just in case and to make immediately testing easier via ../auto-reload.lua
hotspot_check()
