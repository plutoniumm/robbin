-- set braveCount to 0
-- set safariCount to 0
-- set chromeCount to 0
-- move to strings so that multiple windows can be counted
set braveCount to "0"
set safariCount to "0"
set chromeCount to "0"

if application "Brave Browser" is running then
-- count tabs in Brave
	tell application "Brave Browser"
		repeat with w in windows
			set tabCount to 0
			repeat with t in tabs of w
				set tabCount to tabCount + 1
			end repeat
			set braveCount to braveCount & "," & tabCount
		end repeat
	end tell
end if

if application "Safari" is running then
-- count tabs in Safari
	tell application "Safari"
		repeat with w in windows
			set tabCount to 0
			repeat with t in tabs of w
				set tabCount to tabCount + 1
			end repeat
			set safariCount to safariCount & "," & tabCount
		end repeat
	end tell
end if

if application "Google Chrome" is running then
-- count tabs in Chrome
	tell application "Google Chrome"
		repeat with w in windows
			set tabCount to 0
			repeat with t in tabs of w
				set tabCount to tabCount + 1
			end repeat
			set chromeCount to chromeCount & "," & tabCount
		end repeat
	end tell
end if


-- return "braveCount,safariCount,chromeCount"
return braveCount & "|" & safariCount & "|" & chromeCount