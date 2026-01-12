--
--  Author: Hari Sekhon
--  Date: 2026-01-11 19:52:22 -0500 (Sun, 11 Jan 2026)
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
--                      T r a n s m i s s i o n   U t i l s
-- ========================================================================== --

-- luacheck: globals hs pause_transmission resume_transmission quit_transmission

function pause_transmission()
  hs.osascript.applescript([[
    tell application "Transmission"
      if running then pause
    end tell
  ]])
end

function resume_transmission()
  hs.osascript.applescript([[
    tell application "Transmission"
      if running then resume
    end tell
  ]])
end

function quit_transmission()
  hs.osascript.applescript([[
    tell application "Transmission"
      if running then quit
    end tell
  ]])

  -- fallback after a short delay
  hs.timer.doAfter(3, function()
    hs.execute("pkill -x Transmission")
  end)
end
