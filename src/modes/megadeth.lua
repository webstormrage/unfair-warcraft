function createGuard(x, y)
    local hellGuard = CreateUnit(
                 AI_PLAYER,
                 rawCode2Id('Nplh'),
                  x,
                  y,
                  0
            )    
    ShowUnit(hellGuard, false)
    UnitAddAbility(hellGuard, rawCode2Id('ANrf'))
    SetUnitAbilityLevel(hellGuard, rawCode2Id('ANrf'), 3)  
    SetUnitInvulnerable(hellGuard, true)
    IssuePointOrderById(hellGuard, 852238, x, y) -- Rain of Fire
    return hellGuard
end

function megaDethCast()
    SetUnitOwner(MAGIC_CIRCLE_SINGLETON, AI_PLAYER, false)
    ShowUnit(MAGIC_CIRCLE_SINGLETON, false)
    local x = GetOrderPointX()
    local y = GetOrderPointY()
    local i
    local j
    local guards = {}
    for j=1,3 do
        for i=1,15 do
            guards[i] = createGuard(
                  x + math.random( -600, 600 ),
                  y + math.random( -600, 600 )
            )
        end
        TriggerSleepAction(10)
        for i=1,15 do
            RemoveUnit(guards[i])
        end
    end    
end

function megaDethMain()
    MAGIC_CIRCLE_SINGLETON = CreateUnit(AI_PLAYER, rawCode2Id('ncp3'), 0, 0, 0)
    ShowUnit(MAGIC_CIRCLE_SINGLETON, false)
    UnitAddAbilityBJ(rawCode2Id('Andt'), MAGIC_CIRCLE_SINGLETON)

    local megaDethCastTrigger = CreateTrigger()
    TriggerRegisterUnitEvent(megaDethCastTrigger, MAGIC_CIRCLE_SINGLETON, EVENT_UNIT_ISSUED_POINT_ORDER)
    TriggerAddAction(megaDethCastTrigger, megaDethCast)

    MegaDethTrigger = CreateTrigger()
    TriggerRegisterTimerEventPeriodic(MegaDethTrigger, 300)
    TriggerAddAction(MegaDethTrigger, function()
        SetUnitOwner(MAGIC_CIRCLE_SINGLETON, BUFFED_PLAYER, false)
        ShowUnit(MAGIC_CIRCLE_SINGLETON, true)
    end)
    DisableTrigger(MegaDethTrigger)

end