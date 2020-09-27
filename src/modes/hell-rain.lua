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
    HellRainTrigger = CreateTrigger()
    TriggerRegisterTimerEventPeriodic(HellRainTrigger, 120)
    TriggerAddAction(HellRainTrigger, spawnDreadLord)
    DisableTrigger(HellRainTrigger)
end