AddCSLuaFile()
-- Hello welcome! Have fun looking or editing the Code <3 -ADI
SWEP.PrintName = "Thomas The Tank Engine"
SWEP.Author = "ADI & Thendon.exe & Alf21"
SWEP.Instructions = "well..its Thomas"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_EQUIP1
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.InLoadoutFor = nil
SWEP.LimitedStock = true

SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = false
SWEP.AutoSpawnable = false
SWEP.HoldType = "pistol"

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Weight = 7
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.ViewModel = "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"

if CLIENT then
	--TODO change Description if ConVars have been changed
	local desc_conVars = "Shoots a Thomas.\n He will kill all his Friends in his way.\n"
	if(GetConVar("ttt_thomas_det_stop"):GetBool()) then
		desc_conVars = desc_conVars .. "The Detective will STOP Thomas!\n" 
	end
	if(GetConVar("ttt_thomas_det_survive"):GetBool()) then
		desc_conVars = desc_conVars .. "The Detective survives Thomas!\n" 
	end
	desc_conVars = desc_conVars .. "Explodes after " .. GetConVar("ttt_thomas_explode_time"):GetInt() .. " seconds.\n\n PS: ConVars changes wont update the description till mapchange"
	-- end desc convars
	SWEP.Icon = "adithomas/ttt_icon.png"
	SWEP.EquipMenuData = {
		type = "Weapon",
		desc =	  desc_conVars
	}
end

function SWEP:Precache() -- is this ever called ? i guess not
	print("OMG! ADI is wrong! Precache is being called! tell me in Steam-Workshop") -- i am wrong if this appears in console
	util.PrecacheSound("adithomas_bell")

	for i = 1, 6 do
		util.PrecacheSound("adithomas_song_0" .. i)
	end
end

function SWEP:PrimaryAttack()

	self:EmitSound("thomas_bell")
	
	if SERVER then
		local ent = ents.Create("ttt_thomas_ent")
		if not IsValid(ent) then return end
		ent:SetPos(self.Owner:EyePos() + self.Owner:GetAimVector() * 200)
		ent:SetAngles(self.Owner:EyeAngles())
		ent:SetOwner(self.Owner)
		ent.SWEP = self
		math.randomseed(CurTime())
		ent.Sound = "adithomas_song_0"..tostring(math.random(1, 6))
		ent:Spawn()
		self:Remove()
	end
end

