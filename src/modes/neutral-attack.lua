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