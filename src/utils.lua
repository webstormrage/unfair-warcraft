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