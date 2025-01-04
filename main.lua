local mod = RegisterMod("Equity - Better Drops", 1)
local chances = require("chances")
local helpers = require("helpers")

local RECOMMENDED_SHIFT_IDX = 35

mod.random = {}
mod.random.pickups = RNG()

local function unlockedPickups()

    local unlocked_pickups = {}

    for pickup_type, chance in pairs(consts.PICKUP_TYPES_PROBABILITIES) do
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
    local difficulty_modificator = 1

    local rg_init = 0
    local rg_end = 0

    local current_stage = Game():GetLevel():GetStage()

    local rng_value = mod.random.pickups_posibility:RandomInt(1000) + 1

    if player_luck < 1 then
        player_luck = 1
    end

    if player_luck > 15 then
        player_luck = 15
    end

    if room:GetType() == RoomType.ROOM_BOSS then
        return false
    end

    if Game().Difficulty == Difficulty.DIFFICULTY_NORMAL then
        difficulty_modificator = 1.5
    end

    -- Filter unlock items
    local unlocked_pickups = unlockedPickups()


    helpers:debug("Random Number: " .. tostring(rng_value))

    -- Spawn unlocked pickups
    for pickup_type, chance in pairs(unlocked_pickups) do

        rg_init = rg_end

        if current_stage == LevelStage.STAGE6 then

            if helpers:contains(pickup_type, consts.PICKUP_CHESTS) then
                rg_end = rg_init + chance * difficulty_modificator * (4 + player_luck)
            else
                rg_end = rg_init + chance * difficulty_modificator * 0.5
            end

        else

            if helpers:contains(pickup_type, consts.PICKUP_CHESTS) then
                rg_end = rg_init + chance * difficulty_modificator * (player_luck - 1)
            else
                rg_end = rg_init + chance * difficulty_modificator
            end

        end

        helpers:debug("rng_end: " .. tostring(rg_end) .. " PICKUP " .. helpers:pickupName(pickup_type))

        if rg_init <= rng_value and rng_value < rg_end then
            helpers:debug("Spawned unlocked pickup: " .. tostring(pickup_type) .. " Pickup ".. helpers:pickupName(pickup_type))
            Isaac.Spawn(EntityType.ENTITY_PICKUP, pickup_type, 0, position, Vector(0, 0), nil)
            return true
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