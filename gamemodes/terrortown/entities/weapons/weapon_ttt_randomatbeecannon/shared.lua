AddCSLuaFile()

if CLIENT then
    SWEP.PrintName = "Bee Cannon"
    SWEP.Slot = 0
    SWEP.Icon = "vgui/ttt/icon_revolver"
    SWEP.IconLetter = "f"
end

SWEP.Base = "weapon_tttbase"
SWEP.HoldType = "pistol"

SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 5
SWEP.Primary.Recoil = 0.8
SWEP.Primary.Damage = 0
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.ClipMax = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Sound = "Weapon_357.Single"

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 54
SWEP.ViewModel = Model("models/weapons/c_357.mdl")
SWEP.WorldModel = Model("models/weapons/w_357.mdl")

SWEP.Kind = WEAPON_EQUIP1
SWEP.AutoSpawnable = false
SWEP.AmmoEnt = "none"
SWEP.AllowDrop = false
SWEP.IsSilent = false
SWEP.NoSights = true

function SWEP:PrimaryAttack(worldsnd)
    self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    if not worldsnd then
       self:EmitSound(self.Primary.Sound, self.Primary.SoundLevel)
    elseif SERVER then
       sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
    end

    -- TODO: Spawn bee
    -- TODO: Give it forward velocity like it was just shot out of the gun
end