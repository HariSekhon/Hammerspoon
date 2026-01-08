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
--                       Hammerspoon Audio Device Listings
-- ========================================================================== --

-- luacheck: globals getMacMic getFirstBlackholeInputDevice getFirstMultiOutputDevice

local switch_audio = "/opt/homebrew/bin/SwitchAudioSource"

--local function getFirstMultiOutputDevice()
--
-- global now so we can check it from Hammerspoon Console for debugging
--
function getFirstMultiOutputDevice()
    local handle = io.popen(
        switch_audio .. " -a -t output | grep -i -m1 '^Multi-Output Device'"
    )
    if not handle then return nil end
    local result = handle:read("*l")
    handle:close()
    return result
end

function getMacMic()
    local handle = io.popen(
        switch_audio .. " -a -t input | grep -i -m1 '^Mac.*[[:space:]]Microphone$'"
    )
    if not handle then return nil end
    local result = handle:read("*l")
    handle:close()
    return result
end

function getFirstBlackholeInputDevice()
    local handle = io.popen(
        switch_audio .. " -a -t input | grep -i -m1 '^BlackHole'"
    )
    if not handle then return nil end
    local result = handle:read("*l")
    handle:close()
    return result
end
