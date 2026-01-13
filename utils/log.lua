--
--  Author: Hari Sekhon
--  Date: 2026-01-12 21:51:20 -0500 (Mon, 12 Jan 2026)
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
--                             L o g   W r a p p e r
-- ========================================================================== --

-- Because hs.logger is doubling up the timestamps looking ugly in my console
-- so replacing it with a simple print

-- luacheck: globals hs log

function log(msg)
    -- print to Console log for debugging
    --print(msg)
    hs.printf(msg)  -- also goes to macOS unified logging system Console.app
end
