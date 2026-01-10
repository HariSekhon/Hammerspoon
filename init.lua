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
--             H a m m e r s p o o n   L U A   i n i t   s c r i p t
-- ========================================================================== --

-- luacheck: ignore 631

-- Defines Mac system event handlers such as:
--
--      https://github.com/HariSekhon/Knowledge-Base/blob/main/audio.md#automatically-switch-to-using-multi-output-device-when-connecting-headphones

-- 'hs' is a Hammerspoon global
-- luacheck: globals hs notify getFirstBlackholeInputDevice getFirstMultiOutputDevice switchToBlackholeInput switchToMultiOutput

require("auto-reload")
require("audio.devices")
require("audio.switch")
require("audio.watcher")
require("utils.notify")

notify("Hammerspoon Config (Re)Loaded")
