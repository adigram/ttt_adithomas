AddCSLuaFile()

local ULXConVarClass = {}
	ULXConVarClass.list ={}

local function AddonConVar(cv_name,cv_default,cv_type,cv_b_archive,cv_b_notify,cv_b_replicated,cv_desc,ulx_min,ulx_max,ulx_decimal)
	--###Server and Client store ConVars for later use, like so that the Client can create ULX rep_convars
	local ULXConVar = {}
		ULXConVar.cv_name	=	cv_name
		ULXConVar.cv_default	=	cv_default
		ULXConVar.ulx_min	=	ulx_min
		ULXConVar.ulx_max	=	ulx_max
		ULXConVar.ulx_decimal	=	ulx_decimal
		ULXConVar.cv_type	=	cv_type
		ULXConVar.cv_b_archive	=	cv_b_archive
		ULXConVar.cv_b_notify	=	cv_b_notify
		ULXConVar.cv_b_replicated	=	cv_b_replicated
		ULXConVar.cv_desc	=	cv_desc
		table.insert(ULXConVarClass.list,ULXConVar)
	--###Create ConVars
		local tags = {}
		if cv_b_archive then
			table.insert(tags,FCVAR_ARCHIVE) --table.insert(tags,1,FCVAR_ARCHIVE)
		end
		if cv_b_notify then
			table.insert(tags,FCVAR_NOTIFY)
		end
		if cv_b_replicated then
			table.insert(tags,FCVAR_REPLICATED)
		end
		CreateConVar(cv_name, cv_default, tags, cv_desc)
	--###Creates ConVars
end		
local function CreateULXConVar(obj,ulib_acess)	
	
	
	--CreateConVar(obj.cv_name, obj.cv_default, tags, obj.cv_desc) 	--create ConVar
	ULib.replicatedWritableCvar(					--replicate on ULX
		obj.cv_name,
		"rep_" .. obj.cv_name,
		obj.cv_default,
		obj.cv_b_archive,
		obj.cv_b_notify,
		ulib_acess
	)
--[[ ###DEBUG	
		local debug_string = ""
		for key,value in pairs(tags) do
			debug_string = debug_string .. " ".. value
		end
		print("added ConVar: " .. obj.cv_name)
		print("with tags: " .. debug_string)
###DEBUG--]]	
end
local function CreateUI(conv_list)
	if CLIENT then
		hook.Add('TTTUlxModifyAddonSettings', 'ttt_adithomas_hook_to_TTT_ULX_UI', function(name)
--# create BAse Layout
		local thomas_panel = xlib.makelistlayout{w = 415, h = 415, parent = xgui.null} ---BASE LAyout
		
		local thomas_settings = vgui.Create('DCollapsibleCategory', thomas_panel) --- Colapsible
			thomas_settings:SetSize(390, 400)
			thomas_settings:SetExpanded(1)
			thomas_settings:SetLabel('Settings')
			
		local ui_conv_list = vgui.Create('DPanelList', thomas_settings) -- ConVars Listet
			ui_conv_list:SetPos(5, 25)
			ui_conv_list:SetSize(390, 350)
			ui_conv_list:SetSpacing(5)
		
--# add each ConVar to UI_conv_list
		for i,cvar in ipairs(conv_list) do
			--ui_conv_list:AddItem(xlib.makelabel{label = cvar.cv_desc,textcolor = Color( 0, 0, 180),parent = ui_conv_list})
			if (cvar.cv_type == "bool") then
				ui_conv_list:AddItem(xlib.makecheckbox{label =  cvar.cv_desc .. ' (Def. ' .. cvar.cv_default .. ')', repconvar = 'rep_' .. cvar.cv_name, parent = ui_conv_list})
			elseif (cvar.cv_type == "int" or cvar.cv_type == "float") then
				ui_conv_list:AddItem(xlib.makeslider{label = cvar.cv_desc .. ' (Def. ' .. cvar.cv_default .. ')', repconvar = 'rep_' .. cvar.cv_name, min = cvar.ulx_min, max = cvar.ulx_max, decimal = cvar.ulx_decimal, parent = ui_conv_list})
			elseif (cvar.cv_type == "string") then
				ui_conv_list:AddItem(xlib.maketextbox{convar = cvar.cv_desc, text = cvar.cv_default, repconvar = 'rep_' .. cvar.cv_name, enableinput = true, parent = ui_conv_list})
			end
		end
		ui_conv_list:AddItem(xlib.makelabel{label ="Thomas Remake by AllDangerInc aka ADI",textcolor = Color( 0, 0, 180),parent = ui_conv_list})
--# add to ULX
		xgui.hookEvent('onProcessModules', nil, thomas_panel.processModules)
		xgui.addSubModule('Thomas Remake', thomas_panel, nil, name)
		end)
	end
end
local function CustomULXConVars()
	---DEBUG print("###### Thomas CONVAR start #######")
        AddonConVar("ttt_thomas_det_stop",1,"bool",true,true,true,"Detective stops Thomas")
		AddonConVar("ttt_thomas_det_stop_say",1,"bool",true,true,true,"Detective tells chat if he stoped Thomas")
		AddonConVar("ttt_thomas_det_survive",1,"bool",true,true,true,"Detective survives Thomas")
		AddonConVar("ttt_thomas_speed",350,"int",true,true,true,"How fast should Thomas go?",0,1000,0)
		AddonConVar("ttt_thomas_explode_time",15,"int",true,true,true,"Seconds till Thomas explodes:",0,60,0)
		AddonConVar("ttt_thomas_explode_magnitude",256,"int",true,true,true,"Magnitude of explosion:",0,512,0)
		AddonConVar("ttt_thomas_explode_radius",512,"int",true,true,true,"Radius of explosion:",0,1024,0)
	---DEBUG print("###### Thomas CONVAR END #########")
	
    hook.Add('TTTUlxInitCustomCVar', 'ttt_adithomas_hook_to_TTT_ULX_ConVar', function(ulib_acess)
		for i,cvar in ipairs(ULXConVarClass.list) do
			CreateULXConVar(cvar,ulib_acess)
		end
    end)
end
CustomULXConVars()
CreateUI(ULXConVarClass.list)