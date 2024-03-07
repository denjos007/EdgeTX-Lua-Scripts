---------------------------------------------------------------------------
-- This is a simple wodget that shows the stick position; copy           --
-- implementation of the main screen in BW radio interface               --        
--                                                                       --
-- Author:  Joseph Prince Mathew                                         --
-- Date:    2024-03-02                                                   --
-- Version: 1.0.0                                                        --
--                                                                       --
--                                                                       --
-- License GPLv2: http://www.gnu.org/licenses/gpl-2.0.html               --
--                                                                       --
-- This program is free software; you can redistribute it and/or modify  --
-- it under the terms of the GNU General Public License version 2 as     --
-- published by the Free Software Foundation.                            --
--                                                                       --
-- This program is distributed in the hope that it will be useful        --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of        --
-- MERCHANTABILITY or FITNESS FOR borderON PARTICULAR PURPOSE. See the   --
-- GNU General Public License for more details.                          --
---------------------------------------------------------------------------

-- This code chunk is loaded on demand by the LibGUI widget's main script
-- when the create(...) function is run. Hence, the body of this file is
-- executed by the widget's create(...) function.

-- zone and options were passed as arguments to chunk(...)
local zone, options = ...

-- Miscellaneous constants
local HEADER = 40
local WIDTH  = 100
local COL1   = 10
local COL2   = 130
local COL3   = 250
local COL4   = 370
local COL2s  = 120
local TOP    = 44
local ROW    = 28
local HEIGHT = 24

-- The widget table will be returned to the main script
local widget = { }

-- Load the GUI library by calling the global function declared in the main script.
-- As long as LibGUI is on the SD card, any widget can call loadGUI() because it is global.
local libGUI = loadGUI()

-- Instantiate a new GUI object
local gui = libGUI.newGUI()

-- Make a minimize button from a custom element
local custom = gui.custom({ }, LCD_W - 34, 6, 28, 28)

function custom.draw(focused)
  lcd.drawRectangle(LCD_W - 34, 6, 28, 28, libGUI.colors.primary2)
  lcd.drawFilledRectangle(LCD_W - 30, 19, 20, 3, libGUI.colors.primary2)
  if focused then
    custom.drawFocus()
  end
end

function custom.onEvent(event, touchState)
  if (touchState and touchState.tapCount == 2) or (event and event == EVT_VIRTUAL_EXIT) then
    lcd.exitFullScreen()
  end
end


-- Draw on the screen before adding gui elements
function gui.fullScreenRefresh()
  -- Draw header
  lcd.drawFilledRectangle(0, 0, LCD_W, HEADER, COLOR_THEME_SECONDARY1)
  lcd.drawText(COL1, HEADER / 2, "Stick Pos", VCENTER + DBLSIZE + libGUI.colors.primary2)

  lcd.drawText(LCD_W / 2 - 110, LCD_H / 2 - 20, "Coming Soon ... ", DBLSIZE + COLOR_THEME_FOCUS)
  
end

-- Draw in widget mode
function libGUI.widgetRefresh()
  -- Get Stick Positions
  local st1Value = math.floor(getValue(1) / 1024 * 16)
  local st2Value = math.floor(getValue(2) / 1024 * 16)
  local st3Value = math.floor(getValue(3) / 1024 * 16)
  local st4Value = math.floor(getValue(4) / 1024 * 16)
  
  switches = {"sa", "sb", "sc", "sd", "se", "sf", "sg", "sh"}
  switchValues = {0, 0, 0, 0, 0, 0, 0, 0}
  
  for index, switchId in ipairs(switches) do
    local id = getFieldInfo(switchId).id
    local swValue = getValue(id) / 1024 + 1
    switchValues[index] = 3 * (index - 1) + swValue + 1
  end
  

  -- Draw Stick Area
  lcd.drawFilledRectangle(zone.w / 2 - 52, 18, 44, 44, COLOR_THEME_SECONDARY1)
  lcd.drawFilledRectangle(zone.w / 2 + 8, 18, 44, 44, COLOR_THEME_SECONDARY1)
  lcd.drawFilledRectangle(zone.w / 2 - 50, 20, 40, 40, COLOR_THEME_SECONDARY2)
  lcd.drawFilledRectangle(zone.w / 2 + 10, 20, 40, 40, COLOR_THEME_SECONDARY2)
  lcd.drawLine(zone.w / 2 - 20, 40, zone.w / 2 - 40, 40, DOTTED, COLOR_THEME_PRIMARY3)
  lcd.drawLine(zone.w / 2 - 30, 30, zone.w / 2 - 30, 50, DOTTED, COLOR_THEME_PRIMARY3)
  lcd.drawLine(zone.w / 2 + 20, 40, zone.w / 2 + 40, 40, DOTTED, COLOR_THEME_PRIMARY3)
  lcd.drawLine(zone.w / 2 + 30, 30, zone.w / 2 + 30, 50, DOTTED, COLOR_THEME_PRIMARY3)
  
  -- Draw Stick Outputs
  lcd.drawFilledCircle(zone.w / 2 + 30 + st1Value, 40 - st2Value, 3, COLOR_THEME_FOCUS)
  lcd.drawFilledCircle(zone.w / 2 - 30 + st4Value, 40 - st3Value, 3, COLOR_THEME_FOCUS)

  -- Write Stitch Positions
  lcd.drawSwitch(zone.w / 2 - 95, 10, switchValues[1], COLOR_THEME_SECONDARY1)
  lcd.drawSwitch(zone.w / 2 - 95, 25, switchValues[2], COLOR_THEME_SECONDARY1)
  lcd.drawSwitch(zone.w / 2 - 95, 40, switchValues[3], COLOR_THEME_SECONDARY1)
  lcd.drawSwitch(zone.w / 2 - 95, 55, switchValues[4], COLOR_THEME_SECONDARY1)
  lcd.drawSwitch(zone.w / 2 + 60, 10, switchValues[5], COLOR_THEME_SECONDARY1)
  lcd.drawSwitch(zone.w / 2 + 60, 25, switchValues[6], COLOR_THEME_SECONDARY1)
  lcd.drawSwitch(zone.w / 2 + 60, 40, switchValues[7], COLOR_THEME_SECONDARY1)
  lcd.drawSwitch(zone.w / 2 + 60, 55, switchValues[8], COLOR_THEME_SECONDARY1)

end

-- This function is called from the refresh(...) function in the main script
function widget.refresh(event, touchState)
  gui.run(event, touchState)
end

-- Return to the create(...) function in the main script
return widget
