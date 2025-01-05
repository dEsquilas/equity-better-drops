local helpers = {}

function helpers:debug(data)
    Isaac.DebugString("\t\t\t\t\t\t\t\t\t\t\t\t" .. data)
end

function helpers:pickupName(entityId)

    pickupName = "Unknown"

    if entityId == PickupVariant.PICKUP_HEART then
        pickupName = "Heart"
    elseif entityId == PickupVariant.PICKUP_COIN then
        pickupName = "Coin"
    elseif entityId == PickupVariant.PICKUP_KEY then
        pickupName = "Key"
    elseif entityId == PickupVariant.PICKUP_BOMB then
        pickupName = "Bomb"
    elseif entityId == PickupVariant.PICKUP_CHEST then
        pickupName = "Chest"
    elseif entityId == PickupVariant.PICKUP_BOMBCHEST then
        pickupName = "Bomb Chest"
    elseif entityId == PickupVariant.PICKUP_SPIKEDCHEST then
        pickupName = "Spiked Chest"
    elseif entityId == PickupVariant.PICKUP_ETERNALCHEST then
        pickupName = "Eternal Chest"
    elseif entityId == PickupVariant.PICKUP_MIMICCHEST then
        pickupName = "Mimic Chest"
    elseif entityId == PickupVariant.PICKUP_OLDCHEST then
        pickupName = "Old Chest"
    elseif entityId == PickupVariant.PICKUP_WOODENCHEST then
        pickupName = "Wooden Chest"
    elseif entityId == PickupVariant.PICKUP_MEGACHEST then
        pickupName = "Mega Chest"
    elseif entityId == PickupVariant.PICKUP_HAUNTEDCHEST then
        pickupName = "Haunted Chest"
    elseif entityId == PickupVariant.PICKUP_LOCKEDCHEST then
        pickupName = "Locked Chest"
    elseif entityId == PickupVariant.PICKUP_GRAB_BAG then
        pickupName = "Grab Bag"
    elseif entityId == PickupVariant.PICKUP_PILL then
        pickupName = "Pill"
    elseif entityId == PickupVariant.PICKUP_LIL_BATTERY then
        pickupName = "Lil Battery"
    elseif entityId == PickupVariant.PICKUP_COLLECTIBLE then
        pickupName = "Collectible"
    elseif entityId == PickupVariant.PICKUP_TAROTCARD then
        pickupName = "Tarot Card"
    elseif entityId == PickupVariant.PICKUP_BIGCHEST then
        pickupName = "Big Chest"
    elseif entityId == PickupVariant.PICKUP_TRINKET then
        pickupName = "Trinket"
    elseif entityId == PickupVariant.PICKUP_REDCHEST then
        pickupName = "Red Chest"
    elseif entityId == PickupVariant.PICKUP_TROPHY then
        pickupName = "Trophy"
    end

    return pickupName
end

function helpers:contains(item, array)
    for _, value in ipairs(array) do
        if value == item then
            return true
        end
    end
    return false
end

helpers.PICKUP_CHESTS = {
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

return helpers