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
--       T r a n s m i s s i o n   H o t s p o t   Q u i t   W a t c h e r
-- ========================================================================== --

-- luacheck: globals hs log notify quit_transmission

local wifi = require("wifi.utils")

local hotspot_ssids = {
    "iPhone",
    "Android",
    "Hotspot",
}

local on_hotspot = false

-- required to trigger Location Services authorization pop-up - didn't work
--hs.location.get()

local function is_hotspot_wifi()
    -- always returns nil
    --local ssid = hs.wifi.currentNetwork()
    -- replace with custom function that uses networksetup to determine the wifi network name
    local ssid = wifi.current_wifi_ssid()
    --log("Wi-Fi SSID: " .. tostring(ssid))
    if not ssid then
        return false
    end

    for _, name in ipairs(hotspot_ssids) do
        if ssid:lower():find(name:lower(), 1, true) then
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

local wifi_watcher = hs.wifi.watcher.new(function()
    log "WiFi Watcher Fired"
    hs.timer.doAfter(1, hotspot_check)
end)

wifi_watcher:start()
log "Watcher Started: Transmission - WiFi Hotspot"

-- run once at load just in case and to make immediately testing easier via ../auto-reload.lua
-- delayed initial detection still doesn't detect we're on a hotspot during reload
--hs.timer.doAfter(2, function()
--    log "Initial hotspot probe after reload"
--    hotspot_check()
--end)
--
local function initial_probe()
    -- always returns nil
    --local ssid = hs.wifi.currentNetwork()
    -- replace with custom function that uses networksetup to determine the wifi network name
    local ssid = wifi.current_wifi_ssid()
    if ssid then
        log("Initial WiFi SSID detected: " .. ssid)
        hotspot_check()
    else
        --log "SSID not ready yet, retrying"
        hs.timer.doAfter(1, initial_probe)
    end
end

initial_probe()
