function createDragon(x, y)
    local dragon = CreateUnit(AI_PLAYER, rawCode2Id('nbwm'), x, y, 0)
    SetUnitInvulnerable(dragon, true)
    BlzSetUnitBaseDamage(dragon, 1000, 0)
    BlzSetUnitBaseDamage(dragon, 1000, 1)
    return dragon
end

function move(unit, isAgressive)
    local angle = math.random()*2*math.pi
    local x = GetUnitX(unit) + 5000 * math.cos(angle)
    local y = GetUnitY(unit) + 5000 * math.sin(angle)
    if isAgressive then 
        IssuePointOrder(unit, 'attack', x , y)
    else
        IssuePointOrder(unit, 'move', x, y)
    end
end


function dragonsMain()
    local dragons = {}
    local i
    local dragonsControlTrigger = CreateTrigger()
    MOVE_BEHAVIOR_AGGRESSIVE = true
    TriggerRegisterTimerEventPeriodic(dragonsControlTrigger, 12)
    TriggerAddAction(dragonsControlTrigger, function()
        for i = 1,5 do
            move(dragons[i], MOVE_BEHAVIOR_AGGRESSIVE)
        end
        MOVE_BEHAVIOR_AGGRESSIVE = not MOVE_BEHAVIOR_AGGRESSIVE
    end)
    DisableTrigger(dragonsControlTrigger)
    DRAGON_TRIGGER_ENABLED = false

    local dragonTriggerEnable = function()
        EnableTrigger(dragonsControlTrigger)
        for i = 1,5 do
            dragons[i] = createDragon(0,0) 
        end
    end

    local dragonTriggerDisable = function()
        DisableTrigger(dragonsControlTrigger)
        for i = 1,5 do
            RemoveUnit(dragons[i])
        end
    end

    DragonTriggerToggle = function()
        if DRAGON_TRIGGER_ENABLED then
            dragonTriggerDisable()
            DRAGON_TRIGGER_ENABLED = false
        else
            dragonTriggerEnable()
            DRAGON_TRIGGER_ENABLED = true
        end
        return DRAGON_TRIGGER_ENABLED
    end

end