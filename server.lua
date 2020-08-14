ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



RegisterServerEvent('lighT:blackoff')
AddEventHandler('lighT:blackoff', function ()
    TriggerClientEvent('rpv-blackout:clientlightoff', -1)
end)