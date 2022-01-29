ITEM.name = "Civil Protection (UNION)"
ITEM.model = Model("models/wn7new/metropolice/cpuniform.mdl")
ITEM.description = "A civil protection uniform."
ITEM.category = "Outfits"
ITEM.replacements = {
    {"models/willardnetworks/citizens", "models/wn7new/metropolice"},
    {"male", "male_"},
    {"female_", "female"}
}
ITEM.outfitCategory = "uniform"
ITEM.bodyGroups = {
    ["cp_Body"] = 0,
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
    [5] = 0,
    [6] = 0
}

ITEM:Hook("drop", function(item)
	if item:GetData("equip") then
		return false
	end
end)

ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
		local client = item.player
		local char = client:GetCharacter()
		local items = char:GetInventory():GetItems()

		for _, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]

				if (itemTable.pacData and v.outfitCategory == item.outfitCategory and itemTable:GetData("equip")) then
					client:NotifyLocalized(item.equippedNotify or "outfitAlreadyEquipped")
					return false
				end
			end
		end

        char:SetData( "hasUniformOn", true )
        item.player:EmitSound("npc/combine_soldier/gear"..math.random(1, 6)..".wav")
		item:AddOutfit(item.player)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and item:CanEquipOutfit() and
			hook.Run("CanPlayerEquipItem", client, item) != false
	end
}

ITEM.functions.EquipUn = {
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/cross.png",
	OnRun = function(item)
		item:RemoveOutfit(item.player)
        item.player:EmitSound("npc/metropolice/gear"..math.random(1, 6)..".wav")
        item.player:GetCharacter():SetData( "hasUniformOn", false )
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

        if !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and hook.Run("CanPlayerUnequipItem", client, item) != false and client:GetCharacter():GetData("isMaskOn") == false then
            for k, v in ipairs(client:GetBodyGroups()) do
                client:SetBodygroup(v, 0)
            end

            return true
        else return false end
	end
}