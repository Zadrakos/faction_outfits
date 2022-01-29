ITEM.name = "Civil Protection Mask"
ITEM.model = Model("models/wn7new/metropolice/n7_cp_gasmask1.mdl")
ITEM.description = "A civil protection mask."
ITEM.category = "Outfits"
ITEM.outfitCategory = "mask"
ITEM.bodyGroups = {
    ["cp_Head"] = 1
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

        item.player:EmitSound("items/suitchargeok1.wav")
        char:SetData("isMaskOn", true)
		char:SetData("oldCID", char:GetData("cid"))
        char:SetFaction(3)
		item:AddOutfit(item.player)

        char:SetData("oldName", char:GetName())
		char:SetData("oldDesc", char:GetDescription())

        timer.Simple(0.1, function()
            if item:GetData("unitName") == nil then
                item:SetData("unitName", "C2:MPF-RCT." .. math.random(1000, 9999))
            end

			if item:GetData("unitDesc") == nil then
				item:SetData("unitDesc", "A civil protection unit [Change this for a proper desc, YES IT WILL SAVE]")
			end

            char:SetName(item:GetData("unitName"))
			char:SetDescription(item:GetData("unitDesc"))
        end)

		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and item:CanEquipOutfit() and
			hook.Run("CanPlayerEquipItem", client, item) != false and client:GetCharacter():GetData("hasUniformOn") == true
	end
}

ITEM.functions.EquipUn = {
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/cross.png",
	OnRun = function(item)
        local client = item.player
        local character = client:GetCharacter()
		item:RemoveOutfit(item.player)
        item.player:EmitSound("items/suitchargeno1.wav")
        item.player:GetCharacter():SetData( "isMaskOn", false )
        item.player:GetCharacter():SetFaction(2)

        if character:GetName() != item:GetData("unitName") then
            item:SetData("unitName", character:GetName())
        end

		if character:GetDescription() != item:GetData("unitDesc") then
			item:SetData("unitDesc", character:GetDescription())
		end

        item.player:GetCharacter():SetName( item.player:GetCharacter():GetData("oldName") )
		item.player:GetCharacter():SetDescription( item.player:GetCharacter():GetData("oldDesc") )
		item.player:GetCharacter():SetData("cid", char:GetData("oldCID"))

		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false
	end
}