local vehicleNoBelt = {
    [581] = true,
    [509] = true,
    [481] = true,
    [462] = true,
    [521] = true,
    [463] = true,
    [510] = true,
    [522] = true,
    [461] = true,
    [448] = true,
    [468] = true,
    [586] = true,
}

function isVehicleHaveBelt (model)
    return vehicleNoBelt[model] or false
end
