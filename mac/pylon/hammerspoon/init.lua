hs.eventtap
  .new({ hs.eventtap.event.types.keyDown }, function(event)
    local key_code = event:getKeyCode()
    local mod_keys = event:getFlags()
    local app = hs.application.frontmostApplication()
    local app_name = app:name():lower()

    local is_chromium = app_name:match("chromium")

    if is_chromium and mod_keys.ctrl then
      local tab_mappings = {
        [hs.keycodes.map["1"]] = 1,
        [hs.keycodes.map["2"]] = 2,
        [hs.keycodes.map["3"]] = 3,
        [hs.keycodes.map["4"]] = 4,
        [hs.keycodes.map["5"]] = 5,
        [hs.keycodes.map["6"]] = 6,
        [hs.keycodes.map["7"]] = 7,
        [hs.keycodes.map["0"]] = "last",
        [hs.keycodes.map["w"]] = "close",
        [hs.keycodes.map["t"]] = "new",
        [hs.keycodes.map["f"]] = "find",
      }

      if mod_keys.shift and key_code == hs.keycodes.map["t"] then
        reopen_last_closed_tab()
        return true
      end

      if tab_mappings[key_code] then
        if tab_mappings[key_code] == "last" then
          local script = [[
              tell application "Chromium"
                  activate
                  tell front window
                      set tabCount to count of tabs
                      if tabCount > 0 then
                          set active tab index to tabCount
                      end if
                  end tell
              end tell
          ]]
          hs.osascript.applescript(script)
        elseif tab_mappings[key_code] == "close" then
          close_current_tab()
          return true
        elseif tab_mappings[key_code] == "new" then
          open_new_tab()
          return true
        elseif tab_mappings[key_code] == "find" then
          find()
          return true
        else
          switch_to_tab(tab_mappings[key_code])
        end
        return true
      end
    end
  end)
  :start()

function switch_to_tab(tab_index)
  local script = string.format(
    [[
        tell application "Chromium"
            activate
            tell front window
                set active tab index to %d
            end tell
        end tell
    ]],
    tab_index
  )

  hs.osascript.applescript(script)
end

function close_current_tab()
  local script = [[
      tell application "Chromium"
          activate
          tell front window
              close active tab
          end tell
      end tell
  ]]
  hs.osascript.applescript(script)
end

function open_new_tab()
  local script = [[
      tell application "Chromium"
          activate
          tell front window
              make new tab at end of tabs
          end tell
      end tell
  ]]
  hs.osascript.applescript(script)
end

function find()
  hs.eventtap.keyStroke({ "cmd" }, "f")
end

function reopen_last_closed_tab()
  hs.eventtap.keyStroke({ "cmd", "shift" }, "t")
end
