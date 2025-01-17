
--===============================================================================
--=== Made by Alcapone aka suprisex. No script distribution! ====================
--====================== Forked by Zerofour =====================================
--===============================================================================

-- ESX
-- Basics
ESX = nil
local PlayerData                = {}
local radioMenu = false

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

local radioMenu = false

function PrintChatMessage(text)
    TriggerEvent('chatMessage', "system", { 255, 0, 0 }, text)
end

function enableRadio(enable)
  SetNuiFocus(true, true)
  radioMenu = enable

  SendNUIMessage({
    type = "enableui",
    enable = enable
  })
end

-- checks if the / radio command is turned on

RegisterCommand('radio', function(source, args)
    if Config.enableCmd then
      enableRadio(true)
    end
end, false)

RegisterNetEvent('ls-radio:use')
AddEventHandler('ls-radio:use', function()
  enableRadio(true)
end)

-- radio test

RegisterCommand('radiotest', function(source, args)
  local playerName = GetPlayerName(PlayerId())
  local data = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

  print(tonumber(data))

  if data == "nil" then
    exports['mythic_notify']:DoHudText('inform', Config.messages['not_on_radio'])
  else
   exports['mythic_notify']:DoHudText('inform', Config.messages['on_radio'] .. data .. '.00 MHz </b>')
 end

end, false)

--=======
--======= SaltyChat
--=======

RegisterNUICallback('joinRadio', function(data, cb)
  local _source = source
  local PlayerData = ESX.GetPlayerData(_source)
  local playerName = GetPlayerName(PlayerId())
  local getPlayerRadioChannel = exports.saltychat:GetRadioChannel(true)

  if data.channel ~= getPlayerRadioChannel then
    if tonumber(data.channel) <= Config.RestrictedChannels then
      if(PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'fire' or PlayerData.job.name == 'secworker') then
        exports.saltychat:SetRadioChannel(data.channel, true)
        
        exports['b1g_notify']:Notify('true', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz')
      elseif not (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'fire') then
        exports['b1g_notify']:Notify('adm', Config.messages['restricted_channel_error'])
      end
    end
    if tonumber(data.channel) > Config.RestrictedChannels then
      exports.saltychat:SetRadioChannel(data.channel, true)

      exports['b1g_notify']:Notify('true', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz')
    end
  else
    exports['b1g_notify']:Notify('adm', Config.messages['you_on_radio'])
  end

  -- Debug output
  --[[
  PrintChatMessage("radio: " .. data.channel)
  print('radiook')
  ]]

  cb('ok')
end)

--=====
--===== TokoVoip
--=====

--[[ RegisterNUICallback('joinRadio', function(data, cb)
  local _source = source
  local PlayerData = ESX.GetPlayerData(_source)
  local playerName = GetPlayerName(PlayerId())
  local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

  if tonumber(data.channel) ~= tonumber(getPlayerRadioChannel) then
      if tonumber(data.channel) <= Config.RestrictedChannels then
        if(PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'fire') then
          exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
          exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
          exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel))
          exports['mythic_notify']:DoHudText('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        elseif not (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'fire') then
          --- info że nie możesz dołączyć bo nie jesteś policjantem
          exports['mythic_notify']:DoHudText('error', Config.messages['restricted_channel_error'])
        end
      end
      if tonumber(data.channel) > Config.RestrictedChannels then
        exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
        exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
        exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel))
        exports['mythic_notify']:DoHudText('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
      end
    else
      exports['mythic_notify']:DoHudText('error', Config.messages['you_on_radio'] .. data.channel .. '.00 MHz </b>')
    end
    --[[
  --exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
  --exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
  --exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel))
  --PrintChatMessage("radio: " .. data.channel)
  --print('radiook')

  cb('ok')
end) ]]--

--=====
--===== SaltyChat | Leaving the radio
--=====
RegisterNUICallback('leaveRadio', function(data, cb)
  local playerName = GetPlayerName(PlayerId())
  local getPlayerRadioChannel = exports.saltychat:GetRadioChannel(true)

  if getPlayerRadioChannel == nil or getPlayerRadioChannel == '' then
    exports['b1g_notify']:Notify('false', Config.messages['not_on_radio'])
  else
    exports.saltychat:SetRadioChannel('', true)

    exports['b1g_notify']:Notify('false', Config.messages['you_leave'])
  end

  cb('ok')
end)


--=====
--===== TokoVoip | Leaving the radio
--=====

--[[ RegisterNUICallback('leaveRadio', function(data, cb)
   local playerName = GetPlayerName(PlayerId())
   local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

    if getPlayerRadioChannel == "nil" then
      exports['mythic_notify']:DoHudText('inform', Config.messages['not_on_radio'])
        else
          exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
          exports.tokovoip_script:setPlayerData(playerName, "radio:channel", "nil", true)
          exports['mythic_notify']:DoHudText('inform', Config.messages['you_leave'] .. getPlayerRadioChannel .. '.00 MHz </b>')
    end
    cb('ok')
end) ]]

RegisterNUICallback('escape', function(data, cb)

    enableRadio(false)
    SetNuiFocus(false, false)

    cb('ok')
end)

-- net eventy

RegisterNetEvent('ls-radio:use')
AddEventHandler('ls-radio:use', function()
  enableRadio(true)
end)

RegisterNetEvent('ls-radio:onRadioDrop')
AddEventHandler('ls-radio:onRadioDrop', function(source)
  local playerName = GetPlayerName(source)
  local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")


  if getPlayerRadioChannel ~= "nil" then

    exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
    exports.tokovoip_script:setPlayerData(playerName, "radio:channel", "nil", true)
    exports['mythic_notify']:DoHudText('inform', Config.messages['you_leave'] .. getPlayerRadioChannel .. '.00 MHz </b>')

end
end)

Citizen.CreateThread(function()
    while true do
        if radioMenu then
            DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
            DisableControlAction(0, 2, guiEnabled) -- LookUpDown

            DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate

            DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride

            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
        end
        Citizen.Wait(0)
    end
end)
