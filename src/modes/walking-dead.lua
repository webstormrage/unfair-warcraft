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
    WalkingDeadTrigger = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(WalkingDeadTrigger, EVENT_PLAYER_UNIT_DEATH)
    TriggerAddAction(WalkingDeadTrigger, function ()
        local unit = GetDyingUnit()
        local owner = GetOwningPlayer(unit)
        local killer = GetKillingUnit()
        if owner ~= AI_PLAYER and
           owner ~= Player(PLAYER_NEUTRAL_AGGRESSIVE) and
           owner ~= BUFFED_PLAYER and
           owner ~= Player(PLAYER_NEUTRAL_PASSIVE) and
           GetOwningPlayer(killer) == BUFFED_PLAYER and
           not IsUnitType(unit, UNIT_TYPE_STRUCTURE) and
           not IsUnitType(unit, UNIT_TYPE_SUMMONED) and
           not IsUnitType(unit, UNIT_TYPE_HERO) then
            spawnWalkingDead(unit, owner)
        end
    end)
    DisableTrigger(WalkingDeadTrigger)
end