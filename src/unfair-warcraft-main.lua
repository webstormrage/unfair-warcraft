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