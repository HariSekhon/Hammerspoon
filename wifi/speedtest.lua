--
--  Author: Hari Sekhon
--  Date: 2026-01-10 00:50:43 -0500 (Sat, 10 Jan 2026)
--
--  vim:ts=4:sts=4:sw=4:et
--
--  https///github.com/HariSekhon/Templates
--
--  License: see accompanying Hari Sekhon LICENSE file
--
--  If you're using my code you're welcome to connect with me on LinkedIn
--  and optionally send me feedback to help steer this or other code I publish
--
--  https://www.linkedin.com/in/HariSekhon
--

-- ========================================================================== --
--          H a m m e r s p o o n   W i f i   R u n   S p e e d T e s t
-- ========================================================================== --

-- luacheck: globals hs wifiWatcher

-- logger timestamps duplicate with console added timestamps which is ugly
--local log = hs.logger.new("speedtest", "info")

local SPEEDTEST_BUNDLE_ID = "com.ookla.speedtest-macos"
local SPEEDTEST_NAME     = "Speedtest"

local speedtestApp = nil
local speedtestPath = nil

-- Detect Speedtest installation and cache application object
local appPath = hs.application.pathForBundleID(SPEEDTEST_BUNDLE_ID)
if appPath then
    speedtestPath = "bundle-id"
    print("Speedtest installed (bundle ID): " .. appPath)
else
    local app = hs.application.find(SPEEDTEST_NAME)
    if app then
        speedtestPath = "name"
        print("Speedtest found by name (already running)")
    end
end

if not speedtestPath then
    print("Speedtest not installed, Wi-Fi watcher not started")
    return
end

local lastSSID = nil
local lastWasNil = false
local lastRun  = 0
local debounceSeconds = 30

local function launchSpeedtest()
    if speedtestPath == "bundle-id" then
        print("Launching Speedtest via bundle ID")
        hs.application.launchOrFocusByBundleID(SPEEDTEST_BUNDLE_ID)
    else
        print("Launching Speedtest via app name")
        hs.application.launchOrFocus(SPEEDTEST_NAME)
    end
end

local function maybeRunSpeedtest()
    local ssid = hs.wifi.currentNetwork()
    if ssid then
        print("Wi-Fi event, SSID: " .. tostring(ssid))
    else
        -- ignore Wi-Fi disconnection events
        lastWasNil = true
        return
    end

    if ssid == lastSSID then
        print("Same SSID, ignoring")
        return
    end

    -- in practice this doesn't trigger as Hammerspoon console gets:
    --
    --      Wi-Fi event, SSID: nil
    --
    if string.find(ssid, "Phone", 1, true) then
        print("Skipping hotspot network: " .. ssid)
        lastSSID = ssid
        return
    end

    local now = hs.timer.secondsSinceEpoch()
    if now - lastRun < debounceSeconds then
        --print("Debounced")
        return
    end

    lastSSID = ssid
    lastRun  = now

    launchSpeedtest()
end

wifiWatcher = hs.wifi.watcher.new(function()
    -- Delay slightly to allow SSID to stabilise
    hs.timer.doAfter(2, maybeRunSpeedtest)
end)

wifiWatcher:start()
print("Wi-Fi watcher started")
