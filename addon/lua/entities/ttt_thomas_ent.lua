AddCSLuaFile()
-- Hello welcome! Have fun looking or editing the Code <3 -ADI
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Thomas <3"
ENT.Author = "ADI & Thendon.exe & Alf21"
ENT.AutomaticFrameAdvance = true
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.start_time = nil
ENT.end_time = 0
ENT.stoped = false
function ENT:Initialize()
	if SERVER then
		self:SetModel("models/adithomas/ttt_adithomas.mdl")
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER) --maybe change to only Player Collison Group
		self:SetSolid(SOLID_VPHYSICS)
		self:SetPos(self:GetPos()-Vector(0,0,70))
		self:SetMoveType(MOVETYPE_NOCLIP)
		self:SetLocalVelocity(self:GetForward()*GetConVar("ttt_thomas_speed"):GetInt())
		self.start_time = CurTime()
		self.end_time = self.start_time + GetConVar("ttt_thomas_explode_time"):GetInt()
		self:SetTrigger(true)
		self:EmitSound(self.Sound)
		self:UseClientSideAnimation()
		self:ResetSequence("wheel_ani")
		self:SetPlaybackRate(0.01*GetConVar("ttt_thomas_speed"):GetInt())
	end
end

function ENT:Think()
	if SERVER then
		if CurTime() > self.end_time then
			self:StopSound(self.Sound)
			self:Remove()
			return
		end
	end
		
	if CLIENT then
		local lookat = LocalPlayer():EyePos()
		local attachment = self:GetAttachment(self:LookupAttachment( "eyes" ))
		local LocalPos, LocalAng = WorldToLocal( lookat, Angle( 0, 0, 0 ), attachment.Pos, attachment.Ang )
		self:SetEyeTarget( LocalPos )
		return
	end

end

function ENT:StartTouch(entity) --is already only on the Server Side
	if entity == self.Owner then return end
	if entity:IsPlayer() == true then
		if entity:Alive() == false then return end
		if entity:GetRole() == ROLE_DETECTIVE then
			if (not self.stoped and GetConVar("ttt_thomas_det_stop"):GetBool()) then --Detective Stoppes Thomas
				if (GetConVar("ttt_thomas_det_stop_say"):GetBool()) then --Detective Chat message
					entity:Say("AUA! I stopped Thomas!",0);
				end
				self.stoped = true
				self:SetMoveType(MOVETYPE_NONE)
				self:SetPlaybackRate(0.0) -- "stopps" the animation
			end
			if GetConVar("ttt_thomas_det_survive"):GetBool() then --Detective survives
				return
			end
		end
		entity:TakeDamage(1000, self.Owner, self.SWEP)
		self:EmitSound("thomas_bell")
	end
end

if SERVER then
	function ENT:OnRemove()
		self:EmitSound("ambient/explosions/explode_" .. math.random(1, 9) .. ".wav")

		local explode = ents.Create("env_explosion")
		explode:SetPos(self:GetPos())
		explode:SetOwner(self.Owner)
		explode:SetKeyValue("iMagnitude", GetConVar("ttt_thomas_explode_magnitude"):GetInt())
		explode:SetKeyValue("iRadiusOverride", GetConVar("ttt_thomas_explode_radius"):GetInt())
		explode:Spawn()
		explode:Fire("Explode", 0, 0)
	end
end
