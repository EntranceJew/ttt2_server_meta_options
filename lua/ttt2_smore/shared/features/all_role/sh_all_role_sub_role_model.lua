local feat = {}

---comment
---@param ply Player
feat.SetSubRoleModel = function(ply)
	local subrole = ply:GetSubRoleData()
	local thug = GetConVar("sv_smore_" .. subrole.abbr .. "_sub_role_model"):GetString()
	local mdl = string.Trim(thug)
	local force_reset = GetConVar("sv_smore_force_sub_role_model_reset"):GetBool()

	if "" ~= mdl then
		TTT2SMORE.PDATA.seen_models = TTT2SMORE.PDATA.seen_models or {}
		if not TTT2SMORE.PDATA.seen_models[mdl] then
			list.Set( "PlayerOptionsModel", subrole.abbr, mdl )
			player_manager.AddValidModel(subrole.abbr, mdl)
			TTT2SMORE.PDATA.seen_models[mdl] = true
		end
		ply:SetSubRoleModel(mdl)
	else
		if force_reset then
			-- print("HORSEDEBUG", ply, "role model was blanked", subrole)
			ply:SetSubRoleModel(GAMEMODE.playermodel)
		end
	end
	if force_reset then
		hook.Run("TTTPlayerSetColor", ply)
	end
end

TTT2SMORE.HookAdd("TTT2OnRoleAddToSettingsMenu", "all_role_set_sub_role_model", function(role, parent)
	local form = TTT2SMORE.ExtendRoleMenu(role, parent, "header_roles_smore_all_role_general")

	TTT2SMORE.MakeRoleElement(form, role, "sub_role_model", "MakeTextEntry")
end)

TTT2SMORE.HookAdd("SMORECreateRoleConVars", "all_role_set_sub_role_model", function(role)
	TTT2SMORE.MakeCVar(role.abbr .. "_sub_role_model", "")
end)

TTT2SMORE.HookAdd("TTTBeginRoundLivingPlayer", "all_role_set_sub_role_model", function(ply)
	feat.SetSubRoleModel(ply)
end)

TTT2SMORE.HookAdd("TTT2UpdateSubrole", "all_role_set_sub_role_model", function(ply)
	feat.SetSubRoleModel(ply)
end)


TTT2SMORE.HookAdd("SMORECreateConVars", "all_role_set_sub_role_model", function()
	TTT2SMORE.MakeCVar("force_sub_role_model_reset", "0")
end)

TTT2SMORE.HookAdd("SMOREServerAddonSettings", "all_role_set_sub_role_model", function(parent, general)
	TTT2SMORE.MakeElement(general, "force_sub_role_model_reset", "MakeCheckBox")
end)


TTT2SMORE.AddFeature("SubRoleModel", feat)