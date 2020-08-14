ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)



text = true
Citizen.CreateThread(function()
  while true do
      local sleepthread = 1000

      if Vdist2(GetEntityCoords(PlayerPedId(), false), Config.electirictext) < 5 then 
          if Vdist2(GetEntityCoords(PlayerPedId(), false), Config.electirictext) < 1 then
            if text == true then
              DrawText3D(Config.electirictext.x, Config.electirictext.y, Config.electirictext.z, "[E] Hazneye eriş")
                if IsControlJustReleased(0,46) then
                  local plyPed = GetPlayerPed(-1)
                  text = false
                  TriggerEvent("rpv-blackout:startmisson")
                end
              end 
          end
          sleepthread = 5
      else
          sleepthread = 1000
      end
      Citizen.Wait(sleepthread)
  end 
end)


RegisterNetEvent("rpv-blackout:startmisson")
AddEventHandler("rpv-blackout:startmisson", function()
	local coords = GetEntityCoords(GetPlayerPed(-1))
	
	if GetDistanceBetweenCoords(coords, Config.electirictext, true) < 3 then	
		Gecis()
		SetEntityHeading(GetPlayerPed(-1), 154.15)
		SetEntityCoords(GetPlayerPed(-1), Config.electirictext)
    exports['pogressBar']:drawBar(5000, "Sisteme bağlanıyorsun..")
    -- exports["np-taskbar"]:taskBar(4650, "Sisteme bağlanıyorsun..")

		TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE_UPRIGHT", 0, true)
		Citizen.Wait(5000)
		startGame()
	else
    -- exports['mythic_notify']:SendAlert('inform', 'Burada işlem yapamazsın')
    TriggerEvent('notification', 'Burada işlem yapamazsın', 2)
	end
end)


function DrawText3D(x,y,z,text,size)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  SetTextScale(0.35,0.35)
  SetTextFont(4)
  SetTextProportional(3)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(2)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 100)
end

function Gecis()
  DoScreenFadeOut(1000)
  Citizen.Wait(500)
  DoScreenFadeIn(2000)
end

local Gec = false;

function startGame(dropAmount,letter,speed,inter)
  openGui()
  local dropAmount = 15
	local letter = 2
	local speed = 6
	local inter = 900
  play(dropAmount,letter,speed,inter)
  return Gec;
end
			   
local gui = false

function openGui()
    gui = true
    SetNuiFocus(true,true)
    SendNUIMessage({openPhone = true})
end

function play(dropAmount,letter,speed,inter) 
  SendNUIMessage({openSection = "playgame", amount = dropAmount,letterSet = letter,speed = speed,interval = inter})
end

function CloseGui()
    gui = false
    SetNuiFocus(false,false)
    SendNUIMessage({openPhone = false})
end

RegisterNUICallback('close', function(data, cb)
  CloseGui()
  ClearPedTasks(PlayerPedId())
  exports['mythic_notify']:SendAlert('error', 'Hazne açılamadı!')
  cb('ok')
end)

RegisterNUICallback('failure', function(data, cb)
  Gec = false
  CloseGui()
  ClearPedTasks(PlayerPedId())
  exports['mythic_notify']:SendAlert('error', 'Sistem girişi başarısız!')
  exports['mythic_notify']:SendAlert('error', 'Güvenlikler seni fark etti!')
  npccreate1()
  Wait(1)
  npccreate2()
  Wait(1)
  npccreate3()
  Wait(1)
  npccreate4()
  cb('ok')
end)

local lucks =  math.random(1, 2)

RegisterNUICallback('complete', function(data, cb)
  Gec = true
  CloseGui()
  ClearPedTasks(PlayerPedId())
  Citizen.Wait(2500)
  exports['mythic_notify']:SendAlert('inform', 'Şehir elektirik kontrol haznesi devredışı!')
  DownElectiric()
  if lucks < 2 then
    npccreate1()
    exports['mythic_notify']:SendAlert('error', 'Güvenlik seni fark etti!')
  end
  
  cb('ok')
end)


function DownElectiric()
  local ped = PlayerPedId()
  local giveAnim = "anim@mp_player_intmenu@key_fob@" --> Here is your animLib that u want use.
    
	RequestAnimDict(giveAnim)
    while not HasAnimDictLoaded(giveAnim) do
        Citizen.Wait(100)
    end

  
	TaskPlayAnim( ped, "anim@mp_player_intmenu@key_fob@", "fob_click", 8.0, 1.0, 1500, 2, 0, 0, 0, 0 )
	Citizen.Wait(600)
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'elektrik', 0.6)
	TriggerServerEvent('lighT:blackoff')
end

RegisterNetEvent('rpv-blackout:status')
AddEventHandler('rpv-blackout:status', function(status)
  SetArtificialLightsState(status)
end)



RegisterNetEvent('rpv-blackout:clientlightoff')
AddEventHandler('rpv-blackout:clientlightoff', function()
    SetArtificialLightsState(true)
    Citizen.Wait(99899999)
    SetArtificialLightsState(false)
end)

RegisterCommand('ışıklarıaç', function()
  SetArtificialLightsState(false)
end)







function npccreate1()
  local playerped = PlayerPedId()
  RequestModel("s_m_m_armoured_01") 
	while not HasModelLoaded("s_m_m_armoured_01") do
	  Wait(10)
	end
	

		AddRelationshipGroup('DrugsNPC')
		AddRelationshipGroup('PlayerPed')
		pedy = CreatePed(7,'s_m_m_armoured_01', Config.man1.x, Config.man1.y, Config.man1.z, 0 , true ,true  ) 
		SetPedRelationshipGroupHash(pedy, 'DrugsNPC')
		GiveWeaponToPed(pedy,GetHashKey("WEAPON_PISTOL"),250,false,true)
		SetPedArmour(pedy,100)
		SetPedDropsWeaponsWhenDead(pedy, false) 
		SetRelationshipBetweenGroups(5,GetPedRelationshipGroupDefaultHash(playerped),'DrugsNPC')
		SetRelationshipBetweenGroups(5,'DrugsNPC',GetPedRelationshipGroupDefaultHash(playerped))
    TaskCombatPed(pedy,playerped, 0, 16)
    
    exports['mythic_notify']:SendAlert('error', 'Güvenlik gelmeden hemen uzaklaş')

end

function npccreate4()
  local playerped = PlayerPedId()
  RequestModel("cs_prolsec_02") 
	while not HasModelLoaded("cs_prolsec_02") do
	  Wait(10)
	end
	

		AddRelationshipGroup('DrugsNPC4')
		AddRelationshipGroup('PlayerPed')
		pedy = CreatePed(7,'cs_prolsec_02', Config.man4.x, Config.man4.y, Config.man4.z, 0 , true ,true  ) 
		SetPedRelationshipGroupHash(pedy, 'DrugsNPC4')
		GiveWeaponToPed(pedy,GetHashKey("WEAPON_PISTOL"),250,false,true)
		SetPedArmour(pedy,100)
		SetPedDropsWeaponsWhenDead(pedy, false) 
		SetRelationshipBetweenGroups(5,GetPedRelationshipGroupDefaultHash(playerped),'DrugsNPC')
		SetRelationshipBetweenGroups(5,'DrugsNPC',GetPedRelationshipGroupDefaultHash(playerped))
    TaskCombatPed(pedy,playerped, 0, 16)
    
    exports['mythic_notify']:SendAlert('error', 'Güvenlik gelmeden hemen uzaklaş')

end

function npccreate2()
  local playerped = PlayerPedId()
  RequestModel("s_m_m_armoured_01") 
	while not HasModelLoaded("s_m_m_armoured_01") do
	  Wait(10)
	end
	

		AddRelationshipGroup('DrugsNPC2')
		AddRelationshipGroup('PlayerPed')
		pedy = CreatePed(6,'s_m_m_armoured_02', Config.man2.x, Config.man2.y, Config.man2.z, 0 , true ,true  ) 
		SetPedRelationshipGroupHash(pedy, 'DrugsNPC2')
		GiveWeaponToPed(pedy,GetHashKey("WEAPON_SMG"),250,false,true)
		SetPedArmour(pedy,100)
		SetPedDropsWeaponsWhenDead(pedy, false) 
		SetRelationshipBetweenGroups(5,GetPedRelationshipGroupDefaultHash(playerped),'DrugsNPC')
		SetRelationshipBetweenGroups(5,'DrugsNPC',GetPedRelationshipGroupDefaultHash(playerped))
    TaskCombatPed(pedy,playerped, 0, 16)
    
    -- exports['mythic_notify']:SendAlert('error', 'Güvenlik gelmeden hemen uzaklaş')

end


function npccreate3()
  local playerped = PlayerPedId()
  RequestModel("s_m_m_armoured_01") 
	while not HasModelLoaded("s_m_m_armoured_01") do
	  Wait(10)
	end
	

		AddRelationshipGroup('DrugsNPC3')
		AddRelationshipGroup('PlayerPed')
		pedy = CreatePed(6,'s_m_m_armoured_01', Config.man3.x, Config.man3.y, Config.man3.z, 0 , true ,true  ) 
		SetPedRelationshipGroupHash(pedy, 'DrugsNPC3')
		GiveWeaponToPed(pedy,GetHashKey("WEAPON_PISTOL"),250,false,true)
		SetPedArmour(pedy,100)
		SetPedDropsWeaponsWhenDead(pedy, false) 
		SetRelationshipBetweenGroups(5,GetPedRelationshipGroupDefaultHash(playerped),'DrugsNPC')
		SetRelationshipBetweenGroups(5,'DrugsNPC',GetPedRelationshipGroupDefaultHash(playerped))
    TaskCombatPed(pedy,playerped, 0, 16)
    
    -- exports['mythic_notify']:SendAlert('error', 'Güvenlik gelmeden hemen uzaklaş')

end






