--[[
 __    __     __     __   __     ______  
/\ "-./  \   /\ \   /\ "-.\ \   /\__  _\ 
\ \ \-./\ \  \ \ \  \ \ \-.  \  \/_/\ \/ 
 \ \_\ \ \_\  \ \_\  \ \_\\"\_\    \ \_\ 
  \/_/  \/_/   \/_/   \/_/ \/_/     \/_/ 
          LOADER                             
]]--


getgenv().PlaceList = {
    [379614936] = "https://raw.githubusercontent.com/AERO-RBX/MINT/refs/heads/main/games/assassin", 
    [286090429] = "https://raw.githubusercontent.com/PROJOMINT/MINT/refs/heads/main/games/arsenal.lua"
}


local placeId = game.PlaceId
getgenv().Import = getgenv().PlaceList[placeId]


local MPS = game:GetService("MarketplaceService")

local success, info = pcall(function()
    return MPS:GetProductInfo(game.PlaceId)
end)

local placeName = success and info.Name or "Unknown Place"
local gameName = success and game:GetService("MarketplaceService"):GetProductInfo(game.GameId).Name or "Unknown Game"


if getgenv().Import then
    print("Loading script for place:", placeName)
    loadstring(game:HttpGet(getgenv().Import))()
else
    warn("No script available for this game.")
end

