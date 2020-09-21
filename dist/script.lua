function getPlayerPosition(player)
    local structures = GetUnitsOfPlayerMatching(player, Filter(function ()
        return IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE)
    end))
    local target = GroupPickRandomUnit(structures)
    return GetUnitX(target), GetUnitY(target)
end

function getRandomEnemy(player)
    local enemies = GetPlayersEnemies(player)
    return ForcePickRandomPlayer(enemies)
end

function rawCode2Id(rawCode)
    local length = string.len(rawCode)
    local i = 0
    local mul = 1
    local id = 0
    local byte
    repeat
        byte = string.byte(rawCode, length - i)
        id = id + byte * mul
        i = i + 1
        mul = mul * 256
    until i == length
    return id
end


function summonArchimonde()
    RemoveUnit(ARCHIMONDE_SINGLETON)
    local camera = GetCurrentCameraSetup()
    local x = GetCameraTargetPositionX(camera)
    local y = GetCameraTargetPositionY(camera)
    local archimondeId = rawCode2Id('Uwar')
    ARCHIMONDE_SINGLETON = CreateUnit(AI_PLAYER, archimondeId, x, y, 225)
    SetHeroLevelBJ(ARCHIMONDE_SINGLETON, 10, false)
    -- TODO: add summon Dark ritual special effect 1.5sec
end

function despawnArchimonde()
    RemoveUnit(ARCHIMONDE_SINGLETON)
    -- TODO: add summon Dark ritual special effect 1.5sec
end

function summonArchimondeMain()
    local trigger = CreateTrigger()
    TriggerRegisterPlayerChatEvent(trigger, ADMIN_PLAYER, 'archimonde', false) 
    TriggerAddAction(trigger, function ()
        local command = GetEventPlayerChatString()
        if string.find(command,'+archimonde') then
            summonArchimonde()
            print('Archimonde has been spawned')
        end
        if string.find(command,'-archimonde') then
            despawnArchimonde()
            print('Archimonde has been despawned')
        end
    end)
end

function dropItem(itemRawCode, rate, x, y)
    if math.random() < rate then
        local itemId = rawCode2Id(itemRawCode)
        CreateItem(itemId, x, y)
    end
end

function dropRandomItem(itemCodes, rate, x, y)
    local itemRawCode = itemCodes[math.random(#itemCodes)] 
    dropItem(itemRawCode, rate, x, y)
end

function createEpicDrop(x, y)
    dropItem('tst2', 0.3, x, y) -- Book of Force +2
    dropItem('tst2', 0.15, x, y) -- Book of Force +2

    dropItem('tin2', 0.3, x, y) -- Book of Intelligence +2
    dropItem('tin2', 0.15, x, y) -- Book of Intelligence +2

    dropItem('tdx2', 0.3, x, y) -- Book of Agility +2
    dropItem('tdx2', 0.15, x, y) -- Book of Agility +2

    dropItem('tkno', 0.1, x, y) -- Book of Experience

    dropRandomItem({
        'arsh', -- Arcane Shield
        'thdm', -- Thunder daemond
        'crdt', -- Crone of Death
        'mnsf', -- Staff of Intelligence
        'axas', -- Staff of Acients
        'srbd', -- Burning Blade
        'rump', -- Stun 15%
        'schl', -- Scepter of heal
        'rots', -- Sea Scepter
        'shdt' -- Shield of Death
    }, 0.1, x, y)

end

function epicDropMain()
    local dropTrigger = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(dropTrigger, EVENT_PLAYER_UNIT_DEATH)
    TriggerAddAction(dropTrigger, function ()
        local dead = GetDyingUnit()
        local killer = GetKillingUnit()
        if GetOwningPlayer(dead) == Player(PLAYER_NEUTRAL_AGGRESSIVE) and
           GetOwningPlayer(killer) == BUFFED_PLAYER then
           createEpicDrop(GetUnitX(dead), GetUnitY(dead))
        end
    end)
    DisableTrigger(dropTrigger)

    local controlTrigger = CreateTrigger()
    TriggerRegisterPlayerChatEvent(controlTrigger, ADMIN_PLAYER, 'drop', false)
    TriggerAddAction(controlTrigger, function ()
        local command = GetEventPlayerChatString()
        if string.find(command,'+drop') then
            EnableTrigger(dropTrigger)
            print('Epic drop mode enabled')
        end
        if string.find(command,'-drop') then
            DisableTrigger(dropTrigger)
            print('Epic drop mode disabled')
        end
    end)
end

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

function spawnNeutralWave(unitTypeId)
    local targetPlayer = getRandomEnemy(BUFFED_PLAYER)
    local targetX, targetY = getPlayerPosition(targetPlayer)
    CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), unitTypeId, targetX, targetY, 0)
end

function neutralWaveMain()
   local waveTrigger = CreateTrigger()
   TriggerRegisterAnyUnitEventBJ(waveTrigger, EVENT_PLAYER_UNIT_DEATH)
   TriggerAddAction(waveTrigger, function ()
       local diedUnit = GetDyingUnit()
       local killingUnit = GetKillingUnit()
       if GetOwningPlayer(killingUnit) == BUFFED_PLAYER and
          GetOwningPlayer(diedUnit) == Player(PLAYER_NEUTRAL_AGGRESSIVE) then
          spawnNeutralWave(GetUnitTypeId(diedUnit))
        end
   end)
   DisableTrigger(waveTrigger)

   local controlTrigger = CreateTrigger()
   TriggerRegisterPlayerChatEvent(controlTrigger, ADMIN_PLAYER, 'rush', false) 
   TriggerAddAction(controlTrigger, function ()
      local command = GetEventPlayerChatString()
      if string.find(command,'+rush') then
         EnableTrigger(waveTrigger)
         print('Neutral waves mode enabled')
      end
      if string.find(command,'-rush') then
         DisableTrigger(waveTrigger)
         print('Neutral waves mode disabled')
      end
   end)
end

function safeUnit(unit)
    SetUnitX(TELEPORTER_SINGLETON, GetUnitX(unit))
    SetUnitY(TELEPORTER_SINGLETON, GetUnitY(unit))
    SetUnitOwner(TELEPORTER_SINGLETON, GetOwningPlayer(unit), false)
    local saved = CreateUnit(GetOwningPlayer(unit), GetUnitTypeId(unit), GetUnitX(unit), GetUnitY(unit), 225)
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

    local safeTrigger = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(safeTrigger, EVENT_PLAYER_UNIT_DEATH)
    TriggerAddAction(safeTrigger, function ()
        local dead = GetDyingUnit()
        local killer = GetKillingUnit()
        if not IsUnitType(dead, UNIT_TYPE_SUMMONED) and
           not IsUnitType(dead, UNIT_TYPE_STRUCTURE) and
           not IsUnitType(dead, UNIT_TYPE_HERO) and
           GetOwningPlayer(dead) == BUFFED_PLAYER and
           GetOwningPlayer(killer) ~= BUFFED_PLAYER then
            safeUnit(dead)
        end
    end)
    DisableTrigger(safeTrigger)

    local controlTrigger = CreateTrigger()
    TriggerRegisterPlayerChatEvent(controlTrigger, ADMIN_PLAYER, 'rescue', false)
    TriggerAddAction(controlTrigger, function ()
        local command = GetEventPlayerChatString()
        if string.find(command, '+rescue') then
            EnableTrigger(safeTrigger)
            print('Unit rescue mode enabled')
        end
        if string.find(command, '-rescue') then
            DisableTrigger(safeTrigger)
            print('Unit rescue mode disabled')
        end
    end)
end

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

function unfairWarcraftMain()
    BUFFED_PLAYER = Player(1)
    ADMIN_PLAYER = Player(0)
    AI_PLAYER = Player(23)
    SetPlayerAllianceStateAllyBJ(BUFFED_PLAYER, AI_PLAYER, true)

    summonArchimondeMain()
    epicDropMain()
    hellRainMain()
    neutralWaveMain()
    unitRescueMain()
    unitTrainMain()
    walkingDeadMain()
end