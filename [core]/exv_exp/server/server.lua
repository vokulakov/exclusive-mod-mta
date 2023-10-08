local function chekExperiencePlayer(player) -- проверка на опыт
	local LEVEL = getElementData(player, "player.LEVEL")
	local EXP = getElementData(player, "player.EXP")
	local MAX_EXP = getExperienceForLevel(LEVEL)
	if EXP >= MAX_EXP then
		setElementData(player, "player.EXP", 0)
		setElementData(player, "player.LEVEL", LEVEL + 1)
		triggerClientEvent(player, "exv_exp.newLevel", player)
		-- вывести сообщение о получение нового уровня!
	end
end

local function givePlayerExperience(player, current_level) -- выдача опыта
	local LEVEL = getElementData(player, "player.LEVEL")
	local XP = getGivePlayerExperience(current_level, LEVEL)
	setElementData(player, "player.EXP", getElementData(player, "player.EXP") + XP)
	chekExperiencePlayer(player)
end
addEvent("exv_exp.givePlayerExperience", true)
addEventHandler("exv_exp.givePlayerExperience", root, givePlayerExperience)

--[[
addCommandHandler('exp', function(player)
	local LEVEL = 2 -- уровень игрока
	local current_level = 1 -- уровень работы

	local XP = getGivePlayerExperience(current_level, LEVEL)

	local EXP = getElementData(player, "player.EXP") + XP
	local MAX_EXP = getExperienceForLevel(LEVEL)
	outputDebugString(EXP..'/'..MAX_EXP)
end)
]]
--[[
for i = 1, MAX_LEVEL do
	local exp = getExperienceForLevel(i)
	local diff = exp - getExperienceForLevel(i - 1)
	outputChatBox('Level: '..i..' Exp: '..exp..' Diff: '..diff)
end
]]
--[[
local function ComputeExperiencePoints(level, growthModifier)
	return math.ceil((level*50)*(level*growthModifier))
end

for i = 1, 60 do
	local Diff = ComputeExperiencePoints(i, 0.90) - ComputeExperiencePoints(i - 1, 0.90)
	outputChatBox('Level: '..i..' Exp: '..ComputeExperiencePoints(i, 0.90)..' Diff: '..Diff)
end
]]
