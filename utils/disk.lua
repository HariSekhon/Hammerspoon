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
--                              D i s k   U t i l s
-- ========================================================================== --

-- luacheck: globals hs log get_disk_free_gb

function get_disk_free_gb(path)
    -- -k = KB blocks, POSIX-stable
    -- tail -1 avoids headers
    -- awk prints "Available" column
    local cmd = string.format(
        "df -g '%s' | tail -n 1 | awk '{print $4}'",
        path
    )

    -- false = no tty as control characters are messing up my parsesing
    local output = hs.execute(cmd, false)
    if not output then
        return nil
    end
    --log(string.format("Disk free output gb: %s", output))

    local free_gb = tonumber(output:match("(%d+)"))
    if not free_gb then
        return nil
    end

    return free_gb
end
