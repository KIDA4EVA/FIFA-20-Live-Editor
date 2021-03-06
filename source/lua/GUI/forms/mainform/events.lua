require 'lua/GUI/consts';
require 'lua/GUI/forms/mainform/consts';
require 'lua/GUI/forms/mainform/helpers';
-- MainForm Events

-- Make window dragable
function MainTopPanelMouseDown(sender, button, x, y)
    MainWindowForm.dragNow()
end

function MainWindowResizeMouseDown(sender, button, x, y)
    RESIZE_MAIN_WINDOW = {
        allow_resize = true,
        w = MainWindowForm.Width,
        h = MainWindowForm.Height,
        mx = x,
        my = y
    }
end

function LabelLatestLEVerClick()
    if not LATEST_VER then
        return
    end
    shellExecute(string.format(
        "https://www.patreon.com/xAranaktu/posts?filters%stag%s=v%s", 
        "%5B", "%5D",
        tostring(LATEST_VER)
    ))

end


-- stay on top
function MainWindowAlwaysOnTopClick(sender)
    if MainWindowForm.FormStyle == "fsNormal" then
        MainWindowForm.AlwaysOnTop.Visible = false
        MainWindowForm.AlwaysOnTopOn.Visible = true
        MainWindowForm.FormStyle = "fsSystemStayOnTop"
    else
        MainWindowForm.AlwaysOnTop.Visible = true
        MainWindowForm.AlwaysOnTopOn.Visible = false
        MainWindowForm.FormStyle = "fsNormal"
    end
end

-- OnShow -> MainMenuForm
function MainMenuFormShow(sender)
    if HIDE_CE_SCANNER then
        set_ce_mem_scanner_state()
    end

    -- Load Img if attached to the game process
    if BASE_ADDRESS then
        MainLoadImgs()
    end
end

function MainFormRemoveLoadingPanel()
    MainWindowForm.LoadingPanel.Visible = false
    MainLoadImgs()
end


function MainLoadImgs()
    -- load headshot
    local stream = load_headshot(
        tonumber(ADDR_LIST.getMemoryRecordByID(CT_MEMORY_RECORDS['PLAYERID']).Value),
        tonumber(ADDR_LIST.getMemoryRecordByID(CT_MEMORY_RECORDS['SKINTONECODE']).Value),
        tonumber(ADDR_LIST.getMemoryRecordByID(CT_MEMORY_RECORDS['HEADTYPECODE']).Value),
        tonumber(ADDR_LIST.getMemoryRecordByID(CT_MEMORY_RECORDS['HAIRCOLORCODE']).Value)
    )
    MainWindowForm.PlayersEditorImg.Picture.LoadFromStream(stream)
    stream.destroy()

    local ss_c = load_crest(tonumber(ADDR_LIST.getMemoryRecordByID(CT_MEMORY_RECORDS['TEAMID']).Value) + 1)
    MainWindowForm.TeamsEditorImg.Picture.LoadFromStream(ss_c)
    ss_c.destroy()
end

-- Minimize
function MainMinimizeClick(sender)
    MainWindowForm.WindowState = "wsMinimized" 
end

-- Close
function MainExitClick(sender)
    -- Deactivate scripts on Exit while in DEBUG MODE
    if DEBUG_MODE then
        local scripts_record = getAddressList().getMemoryRecordByDescription('Scripts')
        deactive_all(scripts_record)
        scripts_record.Active = false
        -- Deactivate CURRENT_DATE_SCRIPT
        ADDR_LIST.getMemoryRecordByID(CT_MEMORY_RECORDS['CURRENT_DATE_SCRIPT']).Active = false

        -- Deactivate hook loadlibrary & exit cm
        ADDR_LIST.getMemoryRecordByID(4831).Active = false
    end
    -- Deactivate "GUI" script
    ADDR_LIST.getMemoryRecordByID(CT_MEMORY_RECORDS['GUI_SCRIPT']).Active = false
end

-- Show Settings Form
function MainSettingsClick(sender)
    SETTINGS_INDEX = 0
    SettingsForm.show()
end

-- Hide/Show CE
function CEClick(sender)
    SHOW_CE = not SHOW_CE
    getMainForm().Visible = SHOW_CE
end

-- Show Players Editor Form
function PlayersEditorBtnClick(sender)
    MainWindowForm.hide()
    PlayersEditorForm.show()
end
function PlayersEditorImgClick(sender)
    MainWindowForm.hide()
    PlayersEditorForm.show()
end

-- Show Teams Editor Form
function TeamsEditorBtnClick(sender)
    MainWindowForm.hide()
    TeamsEditorForm.show()
end
function TeamsEditorImgClick(sender)
    MainWindowForm.hide()
    TeamsEditorForm.show()
end

-- Show Schedule Editor Form
function ScheduleEditorImgClick(sender)
    MainWindowForm.hide()
    MatchScheduleEditorForm.show()
end
function ScheduleEditorBtnClick(sender)
    MainWindowForm.hide()
    MatchScheduleEditorForm.show()
end

-- Show Transfer Players Form
function PlayersTransferImgClick(sender)
    MainWindowForm.hide()
    TransferPlayersForm.show()
end
function PlayersTransferBtnClick(sender)
    MainWindowForm.hide()
    TransferPlayersForm.show()
end

-- Show Match-fixing Form
function MatchFixingImgClick(sender)
    MainWindowForm.hide()
    MatchFixingForm.show()
end
function MatchFixingBtnClick(sender)
    MainWindowForm.hide()
    MatchFixingForm.show()
end

-- Patreon Button
function PatreonClick(sender)
    shellExecute("https://www.patreon.com/xAranaktu")
end

-- Discord Button
function DiscordClick(sender)
    shellExecute("https://discord.gg/Nb3HX2W")
end
