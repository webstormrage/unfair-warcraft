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