function renderToggleButton(onClick)
    local mainFrame = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
    local button = BlzCreateFrame('ReplayButton', mainFrame, 0, 0)
    BlzFrameSetSize(button, 0.02, 0.02)
    BlzFrameSetPoint(button, FRAMEPOINT_TOPLEFT, mainFrame, FRAMEPOINT_TOPLEFT, 0, -0.025)
    BlzFrameSetText(button, '-')

    local trigger = CreateTrigger()
    
    TriggerAddAction(trigger, onClick)

    BlzTriggerRegisterFrameEvent(trigger, button, FRAMEEVENT_CONTROL_CLICK)
end

function renderModeToggler(trigger, name, iconSrc, x, y)
    local mainFrame = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
    local button = BlzCreateFrame('ScoreScreenBottomButtonTemplate', mainFrame, 0, 0)
    local icon = BlzGetFrameByName('ScoreScreenButtonBackdrop', 0)
    BlzFrameSetTexture(icon, iconSrc, 0, true)
    BlzFrameSetSize(button, 0.04, 0.04)
    BlzFrameSetPoint(button, FRAMEPOINT_TOPLEFT, mainFrame, FRAMEPOINT_TOPLEFT, x, y)
    BlzFrameSetVisible(button, false)

    local controlTrigger = CreateTrigger()
    
    TriggerAddAction(controlTrigger, function()
        if IsTriggerEnabled(trigger) then
            DisableTrigger(trigger)
            print(name..' mode disabled')
        else
            EnableTrigger(trigger)
            print(name..' mode enabled')
        end
    end)

    BlzTriggerRegisterFrameEvent(controlTrigger, button, FRAMEEVENT_CONTROL_CLICK)
    return button
end    


function frameMain()
    local hellRainButton = renderModeToggler(
        HellRainTrigger,
        'Infernal',
        'ReplaceableTextures\\CommandButtons\\BTNInfernal.blp',
        0, -0.055)

    local epicDropButton = renderModeToggler(
        DropTrigger,
        'Epic drop',
        'ReplaceableTextures//CommandButtons//BTNTomeBrown.blp',
        0.05, -0.055)

    local neutralAttackButton = renderModeToggler(
        WaveTrigger,
        'Neutral waves',
        'ReplaceableTextures\\CommandButtons\\BTNGnollWarden.blp',
        0.1, -0.055
    ) 
    
    local unitRescueButton = renderModeToggler(
        SafeTrigger,
        'Unit rescue',
        'ReplaceableTextures\\CommandButtons\\BTNStaffOfSanctuary.blp',
        0, -0.105
    )

    local unitTrainButton = renderModeToggler(
        UnitBuffTrigger,
        'Training units',
        'ReplaceableTextures\\CommandButtons\\BTNOrcMeleeUpThree.blp',
        0.05, -0.105
    )

    local walkingDeadButton = renderModeToggler(
        WalkingDeadTrigger,
        'Walking dead',
        'ReplaceableTextures\\CommandButtons\\BTNAnimateDead.blp',
        0.1, -0.105
    )

    local buttons = {hellRainButton, epicDropButton, neutralAttackButton,
                     unitRescueButton, unitTrainButton, walkingDeadButton }    

    local toggleButton = renderToggleButton(function()
        for i, btn in ipairs(buttons) do
            BlzFrameSetVisible(btn, not BlzFrameIsVisible(btn))
        end
    end)

end