function unfairWarcraftMain()
    BUFFED_PLAYER = Player(1)
    ADMIN_PLAYER = Player(0)
    AI_PLAYER = Player(23)
    SetPlayerAllianceStateAllyBJ(BUFFED_PLAYER, AI_PLAYER, true)

    epicDropMain()
    hellRainMain()
    neutralWaveMain()
    unitRescueMain()
    unitTrainMain()
    walkingDeadMain()
    if GetLocalPlayer() == ADMIN_PLAYER then
        frameMain()
    end
end