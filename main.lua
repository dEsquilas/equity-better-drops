local mod = RegisterMod("Equity - Better Drops", 1)
local helpers = require("helpers")
local modificators = require("modificators")

local RECOMMENDED_SHIFT_IDX = 35

local DEFAULT_CHANCES = {
    [PickupVariant.PICKUP_HEART] = 75,
    [PickupVariant.PICKUP_COIN] = 75,
    [PickupVariant.PICKUP_KEY] = 75,
    [PickupVariant.PICKUP_BOMB] = 75,
    [PickupVariant.PICKUP_PILL] = 50,
    [PickupVariant.PICKUP_GRAB_BAG] = 50,
    [PickupVariant.PICKUP_TAROTCARD] = 50,
    [PickupVariant.PICKUP_BOMBCHEST] = 20,
    [PickupVariant.PICKUP_LIL_BATTERY] = 25,
    [PickupVariant.PICKUP_LOCKEDCHEST] = 20,
    [PickupVariant.PICKUP_CHEST] = 50,
    [PickupVariant.PICKUP_REDCHEST] = 10,
    [PickupVariant.PICKUP_TRINKET] = 10,
    [PickupVariant.PICKUP_SPIKEDCHEST] = 5,
    [PickupVariant.PICKUP_ETERNALCHEST] = 5,
    [PickupVariant.PICKUP_MIMICCHEST] = 5,
    [PickupVariant.PICKUP_OLDCHEST] = 5,
    [PickupVariant.PICKUP_WOODENCHEST] = 5,
    [PickupVariant.PICKUP_HAUNTEDCHEST] = 5,
}

mod.random = {}
mod.random.pickups = RNG()

local function applyModificators(current_chances)

    local stage = Game():GetLevel():GetStage()
    local player = Isaac.GetPlayer(0)
    local player_luck = player.Luck

    if stage == LevelStage.STAGE6 then
        current_chances = modificators:Stage6(current_chances)
    end

    helpers:debug("Applying modificators")
    helpers:debug(tostring(current_chances))

    current_chances = modificators:Luck(current_chances, player_luck)

    helpers:debug("END modificators")

    --local collectibles_modify_drops = {
    --    CollectibleType.COLLECTIBLE_SACK_HEAD,
    --    CollectibleType.COLLECTIBLE_LITTLE_BAGGY,
    --    CollectibleType.COLLECTIBLE_STARTER_DECK,
    --    CollectibleType.COLLECTIBLE_GUPPYS_TAIL,
    --    CollectibleType.COLLECTIBLE_LUCKY_FOOT,
    --    CollectibleType.COLLECTIBLE_THE_RELIC,
    --    CollectibleType.COLLECTIBLE_LIL_CHAD,
    --    CollectibleType.COLLECTIBLE_BOMB_BAG,
    --    CollectibleType.COLLECTIBLE_MYSTERY_SACK,
    --    CollectibleType.COLLECTIBLE_RUNE_BAG,
    --    CollectibleType.COLLECTIBLE_HUMBLE_BUNDLE,
    --    CollectibleType.COLLECTIBLE_LIL_CHEST,
    --
    --}
    --
    --local trinkets_modify_drops = {
    --    TrinketType.COLLECTIBLE_MOMS_PEARLS,
    --    TrinketType.COLLECTIBLE_CHILDS_HEART,
    --    TrinketType.COLLECTIBLE_DAEMONS_TAIL,
    --    TrinketType.COLLECTIBLE_NUH_UH,
    --    TrinketType.COLLECTIBLE_LEFT_HAND,
    --    TrinketType.COLLECTIBLE_GILDED_KEY,
    --}

    local modificator_collectible_functions = {
        [CollectibleType.COLLECTIBLE_SACK_HEAD] = modificators.sackHead,
        [CollectibleType.COLLECTIBLE_LITTLE_BAGGY] = modificators.littleBaggy,
        [CollectibleType.COLLECTIBLE_STARTER_DECK] = modificators.StarterDeck,
        [CollectibleType.COLLECTIBLE_GUPPYS_TAIL] = modificators.GuppyTail,
        [CollectibleType.COLLECTIBLE_LUCKY_FOOT] = modificators.LuckyFoot,
        [CollectibleType.COLLECTIBLE_RELIC] = modificators.TheRelic,
        [CollectibleType.COLLECTIBLE_LITTLE_CHAD] = modificators.LilChad,
        [CollectibleType.COLLECTIBLE_BOMB_BAG] = modificators.BombBag,
        [CollectibleType.COLLECTIBLE_MYSTERY_SACK] = modificators.MisterySack,
        [CollectibleType.COLLECTIBLE_RUNE_BAG] = modificators.RuneBag,
        [CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE] = modificators.HumbleBundle,
        [CollectibleType.COLLECTIBLE_LIL_CHEST] = modificators.LilChest,
    }

    local modificator_trinket_functions = {
        [TrinketType.TRINKET_GILDED_KEY] = modificators.GlidedKey,
        [TrinketType.TRINKET_LEFT_HAND] = modificators.LeftHand,
        [TrinketType.TRINKET_NUH_UH] = modificators.NuhUh,
        [TrinketType.TRINKET_MOMS_PEARL] = modificators.MomsPearls,
        [TrinketType.TRINKET_CHILDS_HEART] = modificators.ChildsHeart,
        [TrinketType.TRINKET_DAEMONS_TAIL] = modificators.DaemonsTail,
    }

    for collectible, func in pairs(modificator_collectible_functions) do
        if player:HasCollectible(collectible) then
            helpers:debug("Collectible: " .. tostring(collectible))
            current_chances = func(modificators, current_chances)
        end
    end

    for trinket, func in pairs(modificator_trinket_functions) do
        if player:HasTrinket(trinket) then
            helpers:debug("Collectible: " .. tostring(collectible))
            current_chances = func(modificators, current_chances)
        end
    end

    return current_chances

end

local function selectChances()

    local c = DEFAULT_CHANCES

    helpers:debug("Default Chances")
    helpers:debug(tostring(c))

    return c

end

local function unlockedPickups()

    local unlocked_pickups = {}
    local pickup_chances = applyModificators(selectChances())

    for pickup_type, chance in pairs(pickup_chances) do
        if pickup_type == PickupVariant.PICKUP_COLLECTIBLE then
            for id = 1, CollectibleType.NUM_COLLECTIBLES do
                local item = Isaac.GetItemConfig():GetCollectible(id)
                if item and item.Unlocked then
                    unlocked_pickups[pickup_type] = chance
                end
            end
        else
            unlocked_pickups[pickup_type] = chance
        end
    end

    return unlocked_pickups

end

local function spawnUnlockedPickup()

    local room = Game():GetRoom()
    local position = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0, true)
    local player = Isaac.GetPlayer()
    local player_luck = player.Luck

    local rg_init = 0
    local rg_end = 0

    local rng_value = mod.random.pickups:RandomInt(1000) + 1

    -- Setup

    if player_luck < 1 then
        player_luck = 1
    end

    if player_luck > 15 then
        player_luck = 15
    end

    if room:GetType() == RoomType.ROOM_BOSS then
        return false
    end

    -- Filter unlock items
    local unlocked_pickups = unlockedPickups()

    helpers:debug("Random Number: " .. tostring(rng_value))

    for pickup_type, chance in pairs(unlocked_pickups) do
        helpers:debug("Pickup: " .. helpers:pickupName(pickup_type) .. " Chance: " .. tostring(chance))
    end

    -- Spawn unlocked pickups
    for pickup_type, chance in pairs(unlocked_pickups) do

        rg_init = rg_end
        rg_end = rg_init + chance

        --if current_stage == LevelStage.STAGE6 then
        --
        --    if helpers:contains(pickup_type, helpers.PICKUP_CHESTS) then
        --        rg_end = rg_init + chance * difficulty_modificator * (4 + player_luck)
        --    else
        --        rg_end = rg_init + chance * difficulty_modificator * 0.5
        --    end
        --
        --else

        -- Apply modificators

        --if helpers:contains(pickup_type, helpers.PICKUP_CHESTS) then
        --    rg_end = rg_init + chance * difficulty_modificator * (player_luck - 1)
        --else

        -- end

        -- end

        -- helpers:debug("rng_end: " .. tostring(rg_end) .. " PICKUP " .. helpers:pickupName(pickup_type))

        if rg_init <= rng_value and rng_value < rg_end then
            helpers:debug("Spawned unlocked pickup: " .. tostring(pickup_type) .. " Pickup " .. helpers:pickupName(pickup_type))
            Isaac.Spawn(EntityType.ENTITY_PICKUP, pickup_type, 0, position, Vector(0, 0), nil)
            --return true
        end
    end

    helpers:debug("No pickup spawned (all probabilities failed)")
    return true
end

-- Initialize random seeds
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(isContinued)
    if isContinued then
        return
    end
    for _, rng in pairs(mod.random) do
        rng:SetSeed(Game():GetSeeds():GetStartSeed(), RECOMMENDED_SHIFT_IDX)
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, spawnUnlockedPickup)