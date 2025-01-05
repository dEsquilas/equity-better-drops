local modificators = {}

local CHESTS = {
    PickupVariant.PICKUP_CHEST,
    PickupVariant.PICKUP_BOMBCHEST,
    PickupVariant.PICKUP_SPIKEDCHEST,
    PickupVariant.PICKUP_ETERNALCHEST,
    PickupVariant.PICKUP_MIMICCHEST,
    PickupVariant.PICKUP_OLDCHEST,
    PickupVariant.PICKUP_WOODENCHEST,
    PickupVariant.PICKUP_HAUNTEDCHEST,
    PickupVariant.PICKUP_LOCKEDCHEST,
    PickupVariant.PICKUP_REDCHEST,
}

function modificators:sackHead(chances)

    local grab_bag_agument = 0

    local variants_affected = {
        PickupVariant.PICKUP_COIN,
        PickupVariant.PICKUP_KEY,
        PickupVariant.PICKUP_BOMB,
        PickupVariant.PICKUP_PILL,
        PickupVariant.PICKUP_TAROTCARD,
        PickupVariant.PICKUP_LIL_BATTERY
    }

    for _, pickup in pairs(variants_affected) do

        grab_bag_agument = grab_bag_agument + chances[pickup] - chances[pickup] * 0.1
        chances[pickup] = chances[pickup] * 0.1

    end

    chances[PickupVariant.PICKUP_GRAB_BAG] = chances[PickupVariant.PICKUP_GRAB_BAG] + grab_bag_agument

    return chances
end

function modificators:littleBaggy(chances)

    local card_chances = chances[PickupVariant.PICKUP_TAROTCARD]
    chances[PickupVariant.PICKUP_TAROTCARD] = 0
    chances[PickupVariant.PICKUP_PILL] = chances[PickupVariant.PICKUP_PILL] + card_chances

    return chances
end

function modificators:StarterDeck(chances)

    local pill_chances = chances[PickupVariant.PICKUP_PILL]
    chances[PickupVariant.PICKUP_PILL] = 0
    chances[PickupVariant.PICKUP_TAROTCARD] = chances[PickupVariant.PICKUP_TAROTCARD] + pill_chances

    return chances
end

function modificators:GuppyTail(chances)

    helpers:debug("IN FUNCITON")
    helpers:debug(tostring(chances))
    helpers:debug("END FUNCITON")

    local increased_pickups = {
        PickupVariant.PICKUP_CHEST,
        PickupVariant.PICKUP_LOCKEDCHEST,
    }

    for _, pickup in pairs(increased_pickups) do
        helpers:debug(tostring(pickup))
        helpers:debug(tostring(chances))
        chances[pickup] = 1000 / 6 -- The probability is 1/3 to be a chest / normal chest, 50% per each
    end

    for pickup,_ in pairs(chances) do

        if index ~= PickupVariant.PICKUP_CHEST and index ~= PickupVariant.PICKUP_LOCKEDCHEST then
            chances[pickup] = chances[pickup] * 0.88 -- Reduce the rest of probabilities in 2/9
        end

    end

    return chances
end

function modificators:LeftHand(chances)

    local chest_probability = 0

    for _, chest in pairs(CHESTS) do
        chest_probability = chest_probability + chances[chest]
        chances[chest] = 0
    end

    chances[PickupVariant.PICKUP_REDCHEST] = chest_probability

    return chances
end

function modificators:GlidedKey(chances)

    local chest_probability = 0

    for _, chest in pairs(CHESTS) do
        chest_probability = chest_probability + chances[chest]
        chances[chest] = 0
    end

    chances[PickupVariant.PICKUP_LOCKEDCHEST] = chest_probability

    return chances
end

function modificators:Stage6(chances)

    for pickup,chance in pairs(chances) do

        if pickup == PickupVariant.PICKUP_CHEST or pickup == PickupVariant.PICKUP_BOMBCHEST or pickup == PickupVariant.PICKUP_LOCKEDCHEST then
            chances[pickup] = chance * 4
        else
            chances[pickup] = chance * 0.8
        end

    end

    return chances
end

function modificators:LuckyFoot(chances)

    for pickup,chance in pairs(chances) do

        if index == PickupVariant.PICKUP_COIN or index == PickupVariant.PICKUP_KEY or index == PickupVariant.PICKUP_BOMB then
            chances[pickup] = chances[pickup] * 1.5
        end

    end

    return chances
end

function modificators:NuhUh(chances)

    local stage = Game():GetLevel():GetStage()

    if stage < LevelStage.STAGE4_1 then -- Nothing changes before the Womb. Don't spawn on Greed, nothing to check there
        return chances
    end

    local chance_to_add = 0

    chance_to_add = chances[PickupVariant.PICKUP_COIN]
    chance_to_add = chance_to_add + chances[PickupVariant.PICKUP_KEY]

    chances[PickupVariant.PICKUP_COIN] = 0
    chances[PickupVariant.PICKUP_KEY] = 0

    chances[PickupVariant.PICKUP_BOMB] = chances[PickupVariant.PICKUP_BOMB] + chance_to_add * 0.2666
    chances[PickpuVariante.PICKUP_HEART] = chances[PickupVariant.PICKUP_HEART] + chance_to_add * 0.2666
    chances[PickupVariant.PICKUP_PILL] = chances[PickupVariant.PICKUP_PILL] + chance_to_add * 0.1666
    chances[PickupVariant.PICKUP_TAROTCARD] = chances[PickupVariant.PICKUP_TAROTCARD] + chance_to_add * 0.1666
    chances[PickupVariant.PICKUP_TRINKET] = chances[PickupVariant.PICKUP_TRINKET] + chance_to_add * 0.0666
    chances[PickupVariant.PICKUP_LIL_BATTERY] = chances[PickupVariant.PICKUP_LIL_BATTERY] + chance_to_add * 0.0666

    return chances
end

function modificators:Luck(chances, luck)

    for pickup,chance in pairs(chances) do
        chances[pickup] = chances[pickup] * (1 + luck)
    end

    return chances
end

function modificators:ChildsHeart(chances)

    chances[PickupVariant.PICKUP_HEART] = chances[PickupVariant.PICKUP_HEART] + 100

    return chances
end

function modificators:DaemonsTail(chances)

    local heart_drop = chances[PickupVariant.PICKUP_HEART]
    chances[PickupVariant.PICKUP_HEART] = chances[PickupVariant.PICKUP_HEART] * 0.2
    chances[PickupVariant.PICKUP_KEY] = chances[PickupVariant.PICKUP_KEY] + heart_drop * 0.8

    return chances
end

function modificators:TheRelic(chances)

    return chances
end

function modificators:LilChad(chances)

    return chances
end

function modificators:BombBag(chances)

    return chances
end

function modificators:MisterySack(chances)

    return chances
end

function modificators:RuneBag(chances)

    return chances
end

function modificators:HumbleBundle(chances)

    return chances
end

function modificators:LilChest(chances)

    return chances
end

function modificators:MomsPearls(chances)

    -- Something to do?

    return chances
end


return modificators