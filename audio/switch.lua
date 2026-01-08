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
--                          Hammerspoon Audio Switcher
-- ========================================================================== --

-- luacheck: ignore 631
-- luacheck: globals hs notify getMacMic getFirstBlackholeInputDevice getFirstMultiOutputDevice switchInputToMacMic switchInputToBlackhole switchOutputToMultiDevice

--local log = hs.logger.new("audioSwitch", "info")
local switch_audio = "/opt/homebrew/bin/SwitchAudioSource"

--local prevOutput = hs.audiodevice.defaultOutputDevice():name()

-- global so we can check it from Hammerspoon Console for debugging
function switchInputToBlackhole()
    local target = getFirstBlackholeInputDevice()

    if target and #target > 0 then
        hs.execute(
            string.format('%s -t input -s "%s"', switch_audio, target)
        )
        hs.notify.new({title="Audio Input Switched", informativeText="Now using: " .. target}):send()
        -- duplicates timestamp in the console and doesn't even prefix info level
        --log.i("Audio Input Switched to " .. target)
        local msg="Audio Input Switched to: " .. target
        notify(msg)
    else
        local msg_device_not_found="No Blackhold Device found - you must first configure one" ..
					               ", see HariSekhon/Knowledge-Base Mac and Audio pages for details"
        -- Deprecated API - doesn't work, use notify function workaround
        --hs.notify.new(
		--    {
		--        title="Audio Input Switch Failed",
		--        informativeText=msg_device_not_found
		--    }
		--):send()
        -- duplicates timestamp in the console and doesn't even prefix info level
        --log.w("Audio Input Switch Failed")
        local msg="Audio Input Switch Failed - " .. msg_device_not_found
        notify(msg)
    end
end

function switchInputToMacMic()
    local target = getMacMic()

    if target and #target > 0 then
        hs.execute(
            string.format('%s -t input -s "%s"', switch_audio, target)
        )
        notify("Audio Input Switched to: " .. target)
    else
        notify(
            "Audio Input Switch Failed - " ..
            "MacOS Input Mic Device not found - this requires investigation"
        )
    end
end

--local function switchToMultiOutput()
--
-- global now so we can check it from Hammerspoon Console for debugging
--
function switchOutputToMultiDevice()
    local target = getFirstMultiOutputDevice()

    if target and #target > 0 then
        --hs.notify.new({title="Audio Output Switched", informativeText="Now using: " .. target}):send()
        hs.execute(
            string.format('%s -t output -s "%s"', switch_audio, target)
        )
        local msg="Audio Output Switched to: " .. target
        notify(msg)
    else
        local msg_device_not_found="No Multi-Output Device found - you must first set it up" ..
					               ", see HariSekhon/Knowledge-Base Mac and Audio pages for details"
        -- Deprecated API - doesn't work, use notify function workaround
        --hs.notify.new(
		--    {
		--        title="Audio Output Switch Failed",
		--        informativeText=msg_device_not_found
		--    }
		--):send()
        -- duplicates timestamp in the console and doesn't even prefix info level
        --log.w("Audio Output Switch Failed")
        local msg="Audio Output Switch Failed - " .. msg_device_not_found
        notify(msg)
    end
end
