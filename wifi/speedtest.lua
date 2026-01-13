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

--local speedtestApp = nil
local speedtestPath = nil

-- Detect Speedtest installation and cache application object
local appPath = hs.application.pathForBundleID(SPEEDTEST_BUNDLE_ID)
if appPath then
    speedtestPath = "bundle-id"
    log("Speedtest installed (bundle ID): " .. appPath)
else
    local app = hs.application.find(SPEEDTEST_NAME)
    if app then
        speedtestPath = "name"
        log("Speedtest found by name (already running)")
    end
end

if not speedtestPath then
    log("Speedtest not installed, Wi-Fi watcher not started")
    return
end

local lastSSID = nil
local lastRun  = 0
local debounceSeconds = 60
local pollTimer = nil

local POLL_INTERVAL = 1      -- seconds
local POLL_TIMEOUT  = 30     -- seconds
local lastSSID      = nil

local function launchSpeedtest(ssid)
    log("Launching Speedtest for SSID: " .. ssid)
    hs.application.launchOrFocusByBundleID(SPEEDTEST_BUNDLE_ID)
end

local function pollForSSID(reason)
    log("Starting SSID poll (" .. reason .. ")")

    local startTime = hs.timer.secondsSinceEpoch()
    local poller

    poller = hs.timer.doEvery(POLL_INTERVAL, function()
        local ssid = hs.wifi.currentNetwork()

        if ssid then
            log("SSID resolved:", ssid)
            poller:stop()

            if ssid == lastSSID then
                log("SSID unchanged, ignoring")
                return
            end

            lastSSID = ssid

            if ssid:find("Phone", 1, true) then
                log("Skipping hotspot network:", ssid)
                return
            end

            launchSpeedtest()
            return
        end

        if hs.timer.secondsSinceEpoch() - startTime > POLL_TIMEOUT then
            log("SSID poll timed out")
            poller:stop()
        end
    end)
end

wifiWatcher = hs.wifi.watcher.new(function()
    log("WiFi Watcher Fired")
    pollForSSID("wifi event")
end)

wifiWatcher:start()
log("Wi-Fi watcher started")
