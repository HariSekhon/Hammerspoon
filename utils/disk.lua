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

-- luacheck: globals hs get_disk_free_gb

function get_disk_free_gb(path)
    local ok, attrs = pcall(hs.fs.volumeInformation, path)
    if not ok or not attrs or not attrs.availableCapacity then
        return nil
    end

    return attrs.availableCapacity / (1024^3)
end
