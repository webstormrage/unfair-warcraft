function spawnDreadLord()
    local targetPlayer = getRandomEnemy(BUFFED_PLAYER)
    local targetX, targetY = getPlayerPosition(targetPlayer)
    local malganisId = rawCode2Id('Umal')
    local dreadLord = CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
         malganisId,
         targetX + math.random( -600, 600 ),
         targetY + math.random( -600, 600 ),
         225
    )
    BlzSetUnitMaxHP(dreadLord, 50)
    local summonEffect = AddSpecialEffectTargetUnitBJ('origin', dreadLord, "Abilities\\Spells\\Undead\\Darksummoning\\DarkSummonTarget.mdl")
    TriggerSleepAction(1.5)
    DestroyEffect(summonEffect)
    TriggerSleepAction(15)
    SetUnitInvulnerable(dreadLord, true)
    SetUnitOwner(dreadLord, AI_PLAYER, false)
    UnitAddAbilityBJ(rawCode2Id('AUin'), dreadLord) --Inferno
    IssuePointOrderById(dreadLord, 852224, targetX, targetY) --Inferno
    TriggerSleepAction(2.5)
    PauseUnit(dreadLord, true)
    summonEffect = AddSpecialEffectTargetUnitBJ('origin', dreadLord, "Abilities\\Spells\\Undead\\Darksummoning\\DarkSummonTarget.mdl")
    TriggerSleepAction(1.5)
    DestroyEffect(summonEffect)
    RemoveUnit(dreadLord)
end

function hellRainMain()
    local hellRainTrigger = CreateTrigger()
    TriggerRegisterTimerEventPeriodic(hellRainTrigger, 120)
    TriggerAddAction(hellRainTrigger, spawnDreadLord)
    DisableTrigger(hellRainTrigger)

    local controlTrigger = CreateTrigger()
    TriggerRegisterPlayerChatEvent(controlTrigger, ADMIN_PLAYER, 'inferno', false)
    TriggerAddAction(controlTrigger, function()
        local command = GetEventPlayerChatString()
        if string.find(command, '+inferno') then
            EnableTrigger(hellRainTrigger)
            print('Infernal mode enabled')
        end
        if string.find(command, '-inferno') then
            DisableTrigger(hellRainTrigger)
            print('Infernal mode disabled')
        end
    end)
end