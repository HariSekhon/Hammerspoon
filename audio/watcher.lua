--
--  Author: Hari Sekhon
--  Date: 2025-10-28 20:33:02 +0300 (Tue, 28 Oct 2025)
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
--                      Hammerspoon Audio Change Watcher
-- ========================================================================== --

-- luacheck: globals hs switchInputToMacMic switchInputToBlackhole switchOutputToMultiDevice

--local audioSwitchLog = hs.logger.new('audioSwitch', 'info')
local log = hs.logger.new("audioWatcher", "info")

local last_switch = 0
local debounce_time = 1  -- seconds

--hs.audiodevice.watcher.setCallback(function(uid, eventName)
hs.audiodevice.watcher.setCallback(function(_, _)
    -- print to Console log for debugging
    local current = hs.audiodevice.defaultOutputDevice():name()
    print("Audio event:", current)

    -- eventName turns out to be 'nil'
    --if eventName == "dOut " then
        if current:match("AirPods") then
            --switchOutputToMultiDevice()
            local now = hs.timer.secondsSinceEpoch()
            if now - last_switch > debounce_time then
                last_switch = now
                log.d("Debounce OK, switching output")
                -- small delay to allow macOS to settle
                hs.timer.doAfter(0.5, switchInputToBlackhole)
                hs.timer.doAfter(0.5, switchOutputToMultiDevice)
            else
                log.d("Debounced, skipping switch")
            end
        elseif current:match("^Mac.*Speakers") then
            local now = hs.timer.secondsSinceEpoch()
            if now - last_switch > debounce_time then
                last_switch = now
                log.d("Debounce OK, switching output")
                -- small delay to allow macOS to settle
                hs.timer.doAfter(0.5, switchInputToMacMic)
            else
                log.d("Debounced, skipping switch")
            end
        elseif current:match("Speakers.*Blackhole")
            or current:match("Multi%-Output Device") then
            local now = hs.timer.secondsSinceEpoch()
            if now - last_switch > debounce_time then
                last_switch = now
                log.d("Debounce OK, switching output")
                -- small delay to allow macOS to settle
                hs.timer.doAfter(0.5, switchInputToBlackhole)
            else
                log.d("Debounced, skipping switch")
            end
        end
        --prevOutput = current
    --end
end)

hs.audiodevice.watcher.start()
