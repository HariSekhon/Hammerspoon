--
--  Author: Hari Sekhon
--  Date: 2026-01-12 21:46:15 -0500 (Mon, 12 Jan 2026)
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
--                       D i s k   S p a c e   A l e r t s
-- ========================================================================== --

-- luacheck: globals hs log notify alert get_disk_free_gb

local check_interval_secs = 300
local watch_path  = os.getenv("HOME")

-- thresholds in GB, highest first
local thresholds_gb = {
    100,
    50,
    20,
}

-- track which thresholds have already fired
local warned = {}

local function warn_if_disk_space_low()
    local free_gb = get_disk_free_gb(watch_path)

    if not free_gb then
        log(
            string.format(
                "ERROR: disk space check failed for %s",
                watch_path
            )
        )
        return
    end

    for _, threshold in ipairs(thresholds_gb) do
        if free_gb <= threshold and not warned[threshold] then
            local msg = string.format(
                "Free Disk Space %.2f GB <= %d GB",
                free_gb,
                threshold
            )
            alert(msg)
            warned[threshold] = true
        end
    end
end

hs.timer.doEvery(check_interval_secs, warn_if_disk_space_low)
log "Watcher Started: Disk Space"
