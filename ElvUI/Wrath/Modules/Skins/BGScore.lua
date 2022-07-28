local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule('Skins')

local _G = _G
local format, pairs = format, pairs
local hooksecurefunc = hooksecurefunc

local GetBattlefieldScore = GetBattlefieldScore
local IsActiveBattlefieldArena = IsActiveBattlefieldArena

function S:SkinWorldStateScore()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.bgscore) then return end

	local WorldStateScoreFrame = _G.WorldStateScoreFrame
	WorldStateScoreFrame:EnableMouse(true)
	WorldStateScoreFrame:StripTextures()
	WorldStateScoreFrame:CreateBackdrop('Transparent')
	WorldStateScoreFrame.backdrop:Point('TOPLEFT', 10, -15)
	WorldStateScoreFrame.backdrop:Point('BOTTOMRIGHT', -113, 67)

	S:HandleCloseButton(WorldStateScoreFrameCloseButton, WorldStateScoreFrame.backdrop)

	_G.WorldStateScoreScrollFrame:StripTextures()
	S:HandleScrollBar(_G.WorldStateScoreScrollFrameScrollBar)

	local buttons = {
		'WorldStateScoreFrameKB',
		'WorldStateScoreFrameDeaths',
		'WorldStateScoreFrameHK',
		'WorldStateScoreFrameDamageDone',
		'WorldStateScoreFrameHealingDone',
		'WorldStateScoreFrameHonorGained',
		'WorldStateScoreFrameName',
		'WorldStateScoreFrameClass',
		'WorldStateScoreFrameTeam'
	}

	for _, button in pairs(buttons) do
		_G[button]:StyleButton()
	end

	S:HandleButton(_G.WorldStateScoreFrameLeaveButton)

	for i = 1, 3 do
		S:HandleTab(_G['WorldStateScoreFrameTab'..i])
		_G['WorldStateScoreFrameTab'..i..'Text']:Point('CENTER', 0, 2)
	end

	_G.WorldStateScoreFrameTab2:Point('LEFT', WorldStateScoreFrameTab1, 'RIGHT', -15, 0)
	_G.WorldStateScoreFrameTab3:Point('LEFT', WorldStateScoreFrameTab2, 'RIGHT', -15, 0)

	_G.WorldStateScoreScrollFrameScrollBar:Point('TOPLEFT', _G.WorldStateScoreScrollFrame, 'TOPRIGHT', 8, -21)
	_G.WorldStateScoreScrollFrameScrollBar:Point('BOTTOMLEFT', _G.WorldStateScoreScrollFrame, 'BOTTOMRIGHT', 8, 38)

	for i = 1, 5 do
		_G['WorldStateScoreColumn'..i]:StyleButton()
	end

	local myName = format('> %s <', E.myname)

	hooksecurefunc('WorldStateScoreFrame_Update', function()
		local inArena = IsActiveBattlefieldArena()
		local offset = FauxScrollFrame_GetOffset(_G.WorldStateScoreScrollFrame)

		local _, name, faction, classToken, realm, classTextColor, nameText

		for i = 1, 20 do
			name, _, _, _, _, faction, _, _, _, classToken = GetBattlefieldScore(offset + i)

			if name then
				name, realm = split('-', name, 2)

				if name == E.myname then
					name = myName
				end

				if realm then
					local color

					if inArena then
						if faction == 1 then
							color = '|cffffd100'
						else
							color = '|cff19ff19'
						end
					else
						if faction == 1 then
							color = '|cff00adf0'
						else
							color = '|cffff1919'
						end
					end

					name = format('%s|cffffffff - |r%s%s|r', name, color, realm)
				end

				classTextColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[classToken] or RAID_CLASS_COLORS[classToken]

				nameText = _G['WorldStateScoreButton'..i..'NameText']
				nameText:SetText(name)
				nameText:SetTextColor(classTextColor.r, classTextColor.g, classTextColor.b)
			end
		end
	end)
end

S:AddCallback('SkinWorldStateScore')
