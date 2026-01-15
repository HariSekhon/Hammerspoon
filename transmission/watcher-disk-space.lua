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
--     T r a n s m i s s i o n   Q u i t   i f   D i s k   S p a c e   L o w
-- ========================================================================== --

-- luacheck: globals hs log is_transmission_running get_disk_free_gb quit_transmission

local check_interval_secs = 120
local min_free_gb = 20
local watch_path  = os.getenv("HOME") .. "/Downloads"

local function quit_transmission_if_disk_space_low()
    if not is_transmission_running() then
        return
    end

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

    if free_gb <= min_free_gb then
        log(
            string.format(
                "free disk space %.2f GB <= %d GB, quitting Transmission",
                free_gb,
                min_free_gb
            )
        )
        quit_transmission()
    end
end

hs.timer.doEvery(check_interval_secs, quit_transmission_if_disk_space_low)
log "Watcher Started: Transmission - Disk Space"
