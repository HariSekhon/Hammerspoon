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
--        H a m m e r s p o o n   A u d i o   C h a n g e   W a t c h e r
-- ========================================================================== --

-- luacheck: globals hs log switchInputToMacMic switchInputToBlackhole switchOutputToMultiDevice

--local audioSwitchLog = hs.logger.new('audioSwitch', 'info')
--local logger = hs.logger.new("audioWatcher", "info")

local state = "idle"
local verify_timer = nil
local verify_retries = 0
local max_retries = 6

local function defaultOutputName()
    local dev = hs.audiodevice.defaultOutputDevice()
    return dev and dev:name() or nil
end

local function stopVerifier()
    if verify_timer then
        verify_timer:stop()
        verify_timer = nil
    end
end

local function startVerifyMultiOutput()
    stopVerifier()
    verify_retries = 0

    verify_timer = hs.timer.doEvery(0.4, function()
        local name = defaultOutputName()
        log("Verifying output:", name or "<nil>")

        if name and name:match("Multi%-Output") then
            log("Multi-Output confirmed, switching input to BlackHole")
            stopVerifier()
            switchInputToBlackhole()
            state = "idle"
            return
        end

        verify_retries = verify_retries + 1
        if verify_retries >= max_retries then
            log("Failed to reach Multi-Output, giving up")
            stopVerifier()
            state = "idle"
        end
    end)
end

hs.audiodevice.watcher.setCallback(function(_, _)
    local name = defaultOutputName()
    if not name then
        log("Audio event: <no default output>")
        return
    end

    log(string.format("Audio event: %s, state: %s", name, state))

    local touchfile = hs.fs.pathToAbsolute("~/.config/no-audio-switching.touchfile")
    if touchfile then
        local attr = hs.fs.attributes(touchfile)
        if attr then
            log(string.format("File '%s' present, skipping audio switching", touchfile))
            return
        end
    end

    -- ===== AirPods / Headphones: automatic sequence =====
    if (name:match("AirPods") or
        name:match("Headphone"))
        and state == "idle" then

        log("AirPods detected -> switching to Multi-Output")
        state = "switching_to_multi_output"

        -- give CoreAudio time to settle before forcing output
        hs.timer.doAfter(0.5, switchOutputToMultiDevice)
        hs.timer.doAfter(0.9, startVerifyMultiOutput)
        hs.timer.doAfter(0.4, function()
            log("Reasserting Multi-Output to work around aggregate steams bug " ..
                "in macOS core audio for AirPods bluetooth")
            switchOutputToMultiDevice()
        end)
        return
    end

    -- ===== Manual Multi-Output selection =====
    if name:match("Multi%-Output")
        and state == "idle" then

        log("Manual Multi-Output detected -> switching input to BlackHole")
        state = "waiting_for_manual_multi"

        -- slight delay avoids fighting CoreAudio
        hs.timer.doAfter(0.4, function()
            switchInputToBlackhole()
            state = "idle"
        end)
        return
    end

    -- ===== Mac Speakers =====
    if name:match("^Mac.*Speakers$")
        and state == "idle" then

        log("Mac Speakers detected -> switching input to Mac mic")
        state = "idle"
        hs.timer.doAfter(0.4, switchInputToMacMic)
        return
    end
end)

hs.audiodevice.watcher.start()
