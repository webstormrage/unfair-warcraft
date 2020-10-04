function renderToggleButton(onClick)
    local mainFrame = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
    local button = BlzCreateFrame('ReplayButton', mainFrame, 0, 0)
    BlzFrameSetSize(button, 0.02, 0.02)
    BlzFrameSetPoint(button, FRAMEPOINT_TOPLEFT, mainFrame, FRAMEPOINT_TOPLEFT, 0, -0.025)
    BlzFrameSetText(button, '-')

    if GetLocalPlayer() ~= ADMIN_PLAYER then
        BlzFrameSetVisible(button, false)
    end
    
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
        if type(trigger) == 'function' then 
            if trigger() then
                print(name..' mode enabled')
            else
                print(name..' mode disabled')
            end
        else
          if IsTriggerEnabled(trigger) then
            DisableTrigger(trigger)
            print(name..' mode disabled')
          else
            EnableTrigger(trigger)
            print(name..' mode enabled')
          end
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

    local megaDethButton = renderModeToggler(
        MegaDethTrigger,
        'Megadeth',
        'ReplaceableTextures\\CommandButtons\\BTNFire.blp',
        0, -0.155
    )

    local dragonButton = renderModeToggler(
        DragonTriggerToggle,
        'Death wings',
        'ReplaceableTextures\\CommandButtons\\BTNBlackDragon.blp',
        0.1, -0.155
    )

    local buttons = {hellRainButton, epicDropButton, neutralAttackButton,
                     unitRescueButton, unitTrainButton, walkingDeadButton,
                     megaDethButton, dragonButton }    

    local toggleButton = renderToggleButton(function()
        if GetLocalPlayer() ~= ADMIN_PLAYER then
            return
        end
        for i, btn in ipairs(buttons) do
            BlzFrameSetVisible(btn, not BlzFrameIsVisible(btn))
        end
    end)

end

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
    DropTrigger = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(DropTrigger, EVENT_PLAYER_UNIT_DEATH)
    TriggerAddAction(DropTrigger, function ()
        local dead = GetDyingUnit()
        local killer = GetKillingUnit()
        if GetOwningPlayer(dead) == Player(PLAYER_NEUTRAL_AGGRESSIVE) and
           GetOwningPlayer(killer) == BUFFED_PLAYER then
           createEpicDrop(GetUnitX(dead), GetUnitY(dead))
        end
    end)
    DisableTrigger(DropTrigger)
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
    HellRainTrigger = CreateTrigger()
    TriggerRegisterTimerEventPeriodic(HellRainTrigger, 120)
    TriggerAddAction(HellRainTrigger, spawnDreadLord)
    DisableTrigger(HellRainTrigger)
end

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

function spawnNeutralWave(unitTypeId)
    local targetPlayer = getRandomEnemy(BUFFED_PLAYER)
    local targetX, targetY = getPlayerPosition(targetPlayer)
    CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), unitTypeId, targetX, targetY, 0)
end

function neutralWaveMain()
   WaveTrigger = CreateTrigger()
   TriggerRegisterAnyUnitEventBJ(WaveTrigger, EVENT_PLAYER_UNIT_DEATH)
   TriggerAddAction(WaveTrigger, function ()
       local diedUnit = GetDyingUnit()
       local killingUnit = GetKillingUnit()
       if GetOwningPlayer(killingUnit) == BUFFED_PLAYER and
          GetOwningPlayer(diedUnit) == Player(PLAYER_NEUTRAL_AGGRESSIVE) then
          spawnNeutralWave(GetUnitTypeId(diedUnit))
        end
   end)
   DisableTrigger(WaveTrigger)
end

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
    UnitBuffTrigger = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(UnitBuffTrigger, EVENT_PLAYER_UNIT_DEATH)
    TriggerAddAction(UnitBuffTrigger, function()
        local killer = GetKillingUnit()
        local dead = GetDyingUnit()
        if not IsUnitType(killer, UNIT_TYPE_HERO) and
           GetOwningPlayer(dead) ~= BUFFED_PLAYER and
           GetOwningPlayer(dead) ~= Player(PLAYER_NEUTRAL_PASSIVE) and
           GetOwningPlayer(killer) == BUFFED_PLAYER then
            trainUnit(killer)
        end
    end)
    DisableTrigger(UnitBuffTrigger)
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

function unfairWarcraftMain()
    BUFFED_PLAYER = Player(1)
    ADMIN_PLAYER = Player(0)
    AI_PLAYER = Player(23)
    SetPlayerAllianceStateAllyBJ(BUFFED_PLAYER, AI_PLAYER, true)
    SetPlayerAllianceStateAllyBJ(AI_PLAYER, BUFFED_PLAYER, true)
    SetPlayerAllianceStateAllyBJ(AI_PLAYER, Player(PLAYER_NEUTRAL_AGGRESSIVE), true)
    SetPlayerAllianceStateAllyBJ(Player(PLAYER_NEUTRAL_AGGRESSIVE), AI_PLAYER, true)

    epicDropMain()
    hellRainMain()
    neutralWaveMain()
    unitRescueMain()
    unitTrainMain()
    walkingDeadMain()
    megaDethMain()
    dragonsMain()
    frameMain()
end