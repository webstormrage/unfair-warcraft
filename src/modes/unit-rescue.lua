function safeUnit(unit)
    SetUnitX(TELEPORTER_SINGLETON, GetUnitX(unit))
    SetUnitY(TELEPORTER_SINGLETON, GetUnitY(unit))
    SetUnitOwner(TELEPORTER_SINGLETON, GetOwningPlayer(unit), false)
    local saved
    if IsUnitType(unit, UNIT_TYPE_HERO) then 
        saved = unit
        ReviveHero(saved, GetUnitX(unit), GetUnitY(unit), false)
    else 
        saved  = CreateUnit(GetOwningPlayer(unit), GetUnitTypeId(unit), GetUnitX(unit), GetUnitY(unit), 225)
    end
    UnitResetCooldown(TELEPORTER_SINGLETON)
    SetUnitLifePercentBJ(saved, 1)
    SetUnitManaPercentBJ(saved, 1)
    UnitUseItemTarget(TELEPORTER_SINGLETON, UnitItemInSlot(TELEPORTER_SINGLETON, 0), saved)
    TriggerSleepAction(0.3)
    SetUnitOwner(TELEPORTER_SINGLETON, AI_PLAYER, false)
    SetUnitX(TELEPORTER_SINGLETON, 0)
    SetUnitY(TELEPORTER_SINGLETON, 0)
end

function unitRescueMain()
    local x = 0
    local y = 0
    TELEPORTER_SINGLETON = CreateUnit(AI_PLAYER, rawCode2Id('Hant'), x, y, 225)
    local staff = CreateItem(rawCode2Id('ssan'), x, y)
    SetItemDroppable(staff, false)
    UnitAddItem(TELEPORTER_SINGLETON, staff)
    SetUnitInvulnerable(TELEPORTER_SINGLETON, true)
    SuspendHeroXP(TELEPORTER_SINGLETON, true)
    UnitRemoveAbilityBJ(rawCode2Id('Aatk'), TELEPORTER_SINGLETON)
    SetUnitPathing(TELEPORTER_SINGLETON, false)
    ShowUnit(TELEPORTER_SINGLETON, false)

    SafeTrigger = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(SafeTrigger, EVENT_PLAYER_UNIT_DEATH)
    TriggerAddAction(SafeTrigger, function ()
        local dead = GetDyingUnit()
        local killer = GetKillingUnit()
        if not IsUnitType(dead, UNIT_TYPE_SUMMONED) and
           not IsUnitType(dead, UNIT_TYPE_STRUCTURE) and
           GetOwningPlayer(dead) == BUFFED_PLAYER and
           GetOwningPlayer(killer) ~= BUFFED_PLAYER and
           GetOwningPlayer(killer) ~=  Player(PLAYER_NEUTRAL_AGGRESSIVE) then
            safeUnit(dead)
        end
    end)
    DisableTrigger(SafeTrigger)
end