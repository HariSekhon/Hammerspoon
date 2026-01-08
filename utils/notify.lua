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
--             Hammerspoon notification
-- ========================================================================== --

-- luacheck: globals hs notify

--local log = hs.logger.new("notifier", "info")

function notify(msg, title)
    title = title or "Hammerspoon"

    -- print to Console log for debugging
    print(msg)
    -- treats everything between [[ ]] as a literal string
    --hs.osascript.applescript([[ display notification msg with title "Hammerspoon" ]])
    local script = string.format(
        'display notification "%s" with title "%s"',
        msg, title
    )
    --hs.osascript.applescript(script)
    hs.notify.new({
        title = title,
        informativeText = msg,
        withdrawAfter = 5,
    }):send()
end
