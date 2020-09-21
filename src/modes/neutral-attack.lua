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