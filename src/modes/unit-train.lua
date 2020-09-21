function trainUnit(unit)
    local effect = AddSpecialEffectTargetUnitBJ('overhead', unit, "Abilities\\Spells\\Items\\AIfb\\AIfbTarget.mdl")
    local damage1 = BlzGetUnitBaseDamage(unit, 0)
    local damage2 = BlzGetUnitBaseDamage(unit, 1)
    local dice1 = BlzGetUnitDiceNumber(unit, 0)
    local dice2 = BlzGetUnitDiceNumber(unit, 1)
    local hp = BlzGetUnitMaxHP(unit)
    local mana = BlzGetUnitMaxMana(unit)
    local armor = BlzGetUnitArmor(unit)

    BlzSetUnitBaseDamage(unit, damage1 + 3, 0)
    BlzSetUnitDiceNumber(unit, dice1 + 1, 0)
    BlzSetUnitMaxHP(unit, hp + 25)
    BlzSetUnitArmor(unit, armor + 1)

    if damage2 > 0 then
        BlzSetUnitBaseDamage(unit, damage2 + 3, 1)
        BlzSetUnitDiceNumber(unit, dice2 + 1, 1)
    end

    if mana > 0 then
        BlzSetUnitMaxMana(unit, mana + 30)
    end
end


function unitTrainMain()
    local buffTrigger = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(buffTrigger, EVENT_PLAYER_UNIT_DEATH)
    TriggerAddAction(buffTrigger, function()
        local killer = GetKillingUnit()
        local dead = GetDyingUnit()
        if not IsUnitType(killer, UNIT_TYPE_HERO) and
           GetOwningPlayer(dead) ~= BUFFED_PLAYER and
           GetOwningPlayer(dead) ~= Player(PLAYER_NEUTRAL_PASSIVE) and
           GetOwningPlayer(killer) == BUFFED_PLAYER then
            trainUnit(killer)
        end
    end)
    DisableTrigger(buffTrigger)

    local controlTrigger = CreateTrigger()
    TriggerRegisterPlayerChatEvent(controlTrigger, ADMIN_PLAYER, 'train', false)
    TriggerAddAction(controlTrigger, function()
        local command = GetEventPlayerChatString()
        if string.find(command, '+train') then
            EnableTrigger(buffTrigger)
            print('Training units mode enabled')
        end
        if string.find(command, '-train') then
            DisableTrigger(buffTrigger)
            print('Training units mode disabled')
        end
    end)
end