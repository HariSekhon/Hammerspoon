--
--  Author: Hari Sekhon
--  Date: 2026-01-10 00:37:19 -0500 (Sat, 10 Jan 2026)
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
--        H a m m e r s p o o n   C o n f i g   A u t o - R e l o a d e r
-- ========================================================================== --

-- Watches for updates to any .lua files under ~/.hammerspoon and triggers an auto-reload
-- upon any changes such as file saves from your editor / IDE

local log = hs.logger.new("reload", "info")

local reloadTimer = nil
local debounceSeconds = 0.5

local function reloadConfig(files)
    for _, file in ipairs(files) do
        if file:sub(-4) == ".lua" then
            log.i("Config change detected: " .. file)

            if reloadTimer then
                reloadTimer:stop()
            end

            reloadTimer = hs.timer.doAfter(debounceSeconds, function()
                log.i("Reloading Hammerspoon config")
                hs.reload()
            end)

            return
        end
    end
end

hs.pathwatcher
    .new(os.getenv("HOME") .. "/.hammerspoon", reloadConfig)
    :start()

log.i("Hammerspoon auto-reload watcher started")
