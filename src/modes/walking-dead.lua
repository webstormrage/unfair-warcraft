function spawnWalkingDead(unit, previousOwner)
    local unitTypeId = GetUnitTypeId(unit)
    local x =  GetUnitX(unit)
    local y = GetUnitY(unit)
    local zombie = CreateUnit(AI_PLAYER, unitTypeId, x, y, 0)
    SetUnitLifePercentBJ(zombie, 25)
    local effect = AddSpecialEffectTargetUnitBJ('origin', zombie, "Abilities\\Spells\\Human\\Banish\\BanishTarget.mdl")
    local targetX, targetY = getPlayerPosition(previousOwner)
    IssuePointOrder(zombie, 'attack', targetX, targetY)
end


function walkingDeadMain()
    local waveTrigger = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(waveTrigger, EVENT_PLAYER_UNIT_DEATH)
    TriggerAddAction(waveTrigger, function ()
        local unit = GetDyingUnit()
        local owner = GetOwningPlayer(unit)
        local killer = GetKillingUnit()
        if owner ~= AI_PLAYER and
           owner ~= Player(PLAYER_NEUTRAL_AGGRESSIVE) and
           owner ~= BUFFED_PLAYER and
           GetOwningPlayer(killer) == BUFFED_PLAYER and
           not IsUnitType(unit, UNIT_TYPE_STRUCTURE) and
           not IsUnitType(unit, UNIT_TYPE_SUMMONED) and
           not IsUnitType(unit, UNIT_TYPE_HERO) then
            spawnWalkingDead(unit, owner)
        end
    end)
    DisableTrigger(waveTrigger)

    local controlTrigger =  CreateTrigger()
    TriggerRegisterPlayerChatEvent(controlTrigger, ADMIN_PLAYER, 'revenge', false)
    TriggerAddAction(controlTrigger, function()
        local command = GetEventPlayerChatString()
        if string.find(command, '+revenge') then
            EnableTrigger(waveTrigger)
            print('Walking dead mode enabled')
        end
        if string.find(command, '-revenge') then
            DisableTrigger(waveTrigger)
            print('Walking dead mode disabled')
        end
    end)
end