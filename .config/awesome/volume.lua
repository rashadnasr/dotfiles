-- Volume widget start
local label_color = "#d791a8"
local info_color = "#ffffff"

-- Function to get the current volume and mute status
local function get_volume()
    local volume, mute
    local success, msg = pcall(function()
        local fd = io.popen("pamixer --get-volume")
        volume = tonumber(fd:read("*all"))
        fd:close()

        local fd_mute = io.popen("pamixer --get-mute")
        mute = fd_mute:read("*all"):match("true")
        fd_mute:close()
    end)

    if not success then
        volume = 0
        mute = false
        print("Error getting volume: ", msg)
    end

    return volume, mute
end

-- Function to update the widget
local function update_widget(widget)
    local volume, mute = get_volume()
    if mute then
        widget.markup = '<span color="' .. label_color .. '">Muted </span>'
    else
        widget.markup = '<span color="' .. label_color .. '">Vol: </span><span color="' .. info_color .. '">' .. volume .. '% </span>'
    end
end

-- Create the widget
local volume_widget = wibox.widget.textbox()

-- Initial update
update_widget(volume_widget)

-- Debounce timer for handling scroll events
local scroll_timer
local function handle_scroll()
    if scroll_timer then
        scroll_timer:stop()
    end
    scroll_timer = gears.timer.start_new(0.1, function()
        update_widget(volume_widget)
        return false
    end)
end

-- Handle scroll event
volume_widget:connect_signal("button::press", function(_, _, _, button)
    if button == 4 then
        -- Scroll up
        awful.spawn("pamixer -i 2", false)
    elseif button == 5 then
        -- Scroll down
        awful.spawn("pamixer -d 2", false)
    elseif button == 1 then
        -- Left click
        awful.spawn("pamixer -t", false)
    end

    -- Update the widget after changing the volume
    handle_scroll()
end)

-- Update the widget periodically
gears.timer.start_new(10, function()
    update_widget(volume_widget)
    return true
end)
-- Volume widget end
 
