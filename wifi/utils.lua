--
--  Author: Hari Sekhon
--  Date: 2026-01-15 19:50:43 -0500 (Thu, 15 Jan 2026)
--
--  vim:ts=4:sts=4:sw=4:et
--
--  https///github.com/HariSekhon/Hammerspoon
--
--  License: see accompanying Hari Sekhon LICENSE file
--
--  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback
--
--  https://www.linkedin.com/in/HariSekhon
--
--

-- ========================================================================== --
--                              W i f i   U t i l s
-- ========================================================================== --

-- luacheck: globals hs

local module = {}

function module.current_wifi_ssid()
    local cmd = [[
        /usr/sbin/networksetup -listnetworkserviceorder |
        grep "Hardware.*Wi-Fi" |
        sed 's/.*: //;s/)$//' |
        xargs /usr/sbin/networksetup -getairportnetwork 2>/dev/null
    ]]

    local output = hs.execute(cmd)
    output = output:gsub("%s+$", "")
    if not output then
        return nil
    end

    -- Expected: "Current Wi-Fi Network: AIRPORTEXPRESS"
    local ssid = output:match("Current Wi%-Fi Network:%s*(.+)")
    return ssid
end

return module
