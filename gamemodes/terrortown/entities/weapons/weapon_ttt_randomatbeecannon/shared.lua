AddCSLuaFile()

if CLIENT then
    SWEP.PrintName = "Bee Cannon"
    SWEP.Slot = 9
    SWEP.Icon = "vgui/ttt/icon_revolver"
    SWEP.IconLetter = "f"
end

SWEP.Base = "weapon_tttbase"
SWEP.HoldType = "rpg"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Weight = 5

SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 5
SWEP.Primary.Recoil = 50
SWEP.Primary.Damage = 0
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.ClipMax = -1
SWEP.Primary.DefaultClip = -1

SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 55
SWEP.ViewModel = Model("models/weapons/v_rpg.mdl")
SWEP.WorldModel = Model("models/weapons/w_rocket_launcher.mdl")

SWEP.Kind = WEAPON_EQUIP1
SWEP.AutoSpawnable = false
SWEP.AmmoEnt = "none"
SWEP.AllowDrop = false
SWEP.IsSilent = false
SWEP.NoSights = true

local ShootSound = Sound("weapons/grenade_launcher1.wav")

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self:EmitSound(ShootSound)

    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    if SERVER then
        -- Height should be roughly half way up the player to show like it kinda came out of the gun
        local height = owner:Crouching() and 14 or 32

        -- Spawn a bee and give it forward velocity like it was just shot out of the gun
        local bee = Randomat:SpawnBee(owner, nil, height)

		local ang = self.Owner:EyeAngles()
        bee:SetPos(self.Owner:GetShootPos() + ang:Forward() * 50 + ang:Right() * 1 - ang:Up() * 1)
        bee:SetAngles(ang)
        local physobj = bee:GetPhysicsObject()
        if IsValid(physobj) then
            physobj:SetVelocity(owner:GetAimVector() * 750)
        end
    end

    if owner:IsNPC() or (not owner.ViewPunch) then return end
    owner:ViewPunch(Angle(util.SharedRandom(self:GetClass(), -0.2, -0.1, 0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),  -0.1, 0.1, 1) * self.Primary.Recoil, 0))
end

function SWEP:SecondaryAttack()
	-- Do nothing
end