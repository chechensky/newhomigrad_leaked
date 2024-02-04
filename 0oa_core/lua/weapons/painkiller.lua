SWEP.Base = 'weapon_base'
AddCSLuaFile()

SWEP.PrintName = "Обезболивающее"
SWEP.Author = "Painkillers"
SWEP.Purpose = "Снижает боль"

SWEP.Slot = 3
SWEP.SlotPos = 3
SWEP.Spawnable = true

SWEP.ViewModel = "models/w_models/weapons/w_eq_painpills.mdl"
SWEP.WorldModel = "models/w_models/weapons/w_eq_painpills.mdl"
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawCrosshair = false
local healsound = Sound("snds_jack_gmod/ez_medical/15.wav")
function SWEP:Initialize()
	self:SetHoldType( "slam" )
	if ( CLIENT ) then return end
end

if(CLIENT)then
	function SWEP:PreDrawViewModel(vm,wep,ply)
	end
	function SWEP:GetViewModelPosition(pos,ang)
		pos=pos-ang:Up()*10+ang:Forward()*30+ang:Right()*7
		ang:RotateAroundAxis(ang:Up(),90)
		ang:RotateAroundAxis(ang:Right(),-10)
		ang:RotateAroundAxis(ang:Forward(),-10)
		return pos,ang
	end
	function SWEP:DrawWorldModel()
		self:DrawModel()
		if (IsValid(self:GetOwner())) then 
		local Pos,Ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")) 
			if((Pos)and(Ang))then
				self:SetRenderOrigin(Pos+Ang:Forward()*3.2+Ang:Right()*2+Ang:Up()*2)
				Ang:RotateAroundAxis(Ang:Up(),0)
				Ang:RotateAroundAxis(Ang:Right(),0)
				Ang:RotateAroundAxis(Ang:Forward(),180)
				self:SetModelScale(1)
				self:SetRenderAngles(Ang)
				self:DrawModel()
			end
		end
	end
end
function SWEP:PrimaryAttack()
self.Owner:SetAnimation(PLAYER_ATTACK1)
if(SERVER)then
self.Owner:SetNWInt("painlosing",math.Clamp(self.Owner:GetNWInt("painlosing")+5,1,15))
self:Remove()
sound.Play(healsound, self:GetPos(),75,100,0.5)
self.Owner:SelectWeapon("weapon_hands")
end
end
function SWEP:SecondaryAttack()
self.Owner:SetAnimation(PLAYER_ATTACK1)
if(SERVER)then
local tr = util.TraceHull( {
	start = self.Owner:GetShootPos(),
	endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 48 ),
	filter = self.Owner,
	mins = Vector( -10, -10, -10 ),
	maxs = Vector( 10, 10, 10 ),
} )
WhomILookinAt=tr.Entity
if IsValid(WhomILookinAt) then
if WhomILookinAt:IsRagdoll() then
if !IsValid(RagdollOwner(WhomILookinAt)) then return nil end
RagdollOwner(WhomILookinAt):SetNWInt("painlosing",math.Clamp(RagdollOwner(WhomILookinAt):GetNWInt("painlosing")+5,1,15))
self:Remove()
sound.Play(healsound, self:GetPos(),75,100,0.5)
self.Owner:SelectWeapon("weapon_hands")
end
end
end
end