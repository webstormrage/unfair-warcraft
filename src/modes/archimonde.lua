
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