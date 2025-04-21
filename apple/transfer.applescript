if application "Safari" is running then
tell application "Safari"
    set _tabs to tabs of window 1
    repeat with _tab in _tabs
        -- get tab name and url
        set _tabName to name of _tab
        set _tabURL to URL of _tab
        -- open got tab in Brave
        tell application "Brave Browser"
            activate
            open location _tabURL
        end tell
        -- close tab in Safari
        tell application "Safari"
            close _tab
        end tell
    end repeat
end tell
end if

-- tell application "Brave Browser"
--     repeat with w in windows
--         repeat with t in tabs of w
--             set _tabURL to URL of _tab
--             if _tabURL contains "archiveofourown"
--                 log _tabURL
--             end if
--             end repeat
--     end repeat
-- end tell