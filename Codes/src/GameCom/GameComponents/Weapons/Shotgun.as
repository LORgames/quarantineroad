package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.BitmapData;
	import flash.ui.Keyboard;
	import GameCom.GameComponents.PlayerCharacter;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.TrophyHelper;
	import GameCom.Managers.BulletManager;
	import GameCom.Managers.GUIManager;
	import GameCom.SystemComponents.WeaponToast;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import LORgames.Engine.Stats;
	/**
	 * ...
	 * @author Paul
	 */
	public class Shotgun implements IWeapon {
		private var MAX_AMMO:int = 40; //LOLOLOLOL TOO MANY AMMO.
		
		public const RANGE:Number = 5;
		public const DAMAGE:Number = 5;
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		public var FIRE_RATE:Number = 0.5;
		public var fireTime:Number = 0;
		
		private var collected:Boolean = false;
		private var upgraded:Boolean = false;
		private var shells:int = 10;
		
		private var totalKills:int = 0;
		
		public function Shotgun(body:b2Body) {
			AddSafe(body);
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2, player:PlayerCharacter):Boolean {
			if (fireTime > FIRE_RATE) {
				if(player.ShouldFire() && collected) {
					if(shells > 0) {
						AudioController.PlaySound(AudioStore.GetShotgunFireSound());
						
						fireTime -= FIRE_RATE;
						BulletManager.I.FireAt(location, BasicBullet, this,-3*Math.PI/10, RANGE, DAMAGE);
						BulletManager.I.FireAt(location, BasicBullet, this,-2*Math.PI/10, RANGE, DAMAGE);
						BulletManager.I.FireAt(location, BasicBullet, this,-1*Math.PI/10, RANGE, DAMAGE);
						BulletManager.I.FireAt(location, BasicBullet, this,-0*Math.PI/10, RANGE, DAMAGE);
						BulletManager.I.FireAt(location, BasicBullet, this, 1*Math.PI/10, RANGE, DAMAGE);
						BulletManager.I.FireAt(location, BasicBullet, this, 2*Math.PI/10, RANGE, DAMAGE);
						BulletManager.I.FireAt(location, BasicBullet, this, 3 * Math.PI / 10, RANGE, DAMAGE);
						
						shells--;
					}
					
					if (shells > 0) {
						AudioController.PlaySound(AudioStore.ShotgunReload);
					}
				}
			} else {
				fireTime += dt;
			}
			
			if (shells == 0) return false;
			return true;
		}
		
		public function Upgrade():void {
			if(collected) {
				upgraded = true;
				FIRE_RATE = 0.5;
				GUIManager.I.RedrawWeapons();
				WeaponToast.I.AddWeaponPickup("Combat Shotgun", ThemeManager.Get("WeaponIcons/w05_combat_shotgun.png"));
			} else {
				collected = true;
				WeaponToast.I.AddWeaponPickup("Shotgun", ThemeManager.Get("WeaponIcons/w04_shotgun.png"));
			}
		}
		
		public function AddAmmo():void {
			if(collected) shells += Math.random() * 5 + 5;
			if (shells > MAX_AMMO) shells = MAX_AMMO;
		}
		
		public function IsMaxAmmo():Boolean {
			return (shells == MAX_AMMO);
		}
		
		private var isActive:Boolean = false;
		public function Activate():void { isActive = true; }
		public function Deactivate():void { isActive = false; }
		public function IsActive():Boolean { return isActive; }
		
		public function GetAmmoReadout():String {
			if(collected) {
				return shells.toString();
			}
			
			return "";
		}
		
		public function AddSafe(body:b2Body):void {
			safeFixtures.push(body);
		}
		
		public function IsSafe(body:b2Body):Boolean {
			if (safeFixtures.indexOf(body) > -1) {
				return true;
			}
			
			return false;
		}
		
		public function GetIcon():BitmapData {
			if (!collected) {
				return null;
			} else if(!upgraded) {
				return ThemeManager.Get("WeaponIcons/w04_shotgun.png");
			} else {
				return ThemeManager.Get("WeaponIcons/w05_combat_shotgun.png");
			}
		}
		
		public function GetPlayerBody():BitmapData {
			if (!collected) {
				return ThemeManager.Get("Player/top/base.png");
			} else if(!upgraded) {
				return ThemeManager.Get("Player/top/base04_shotgun.png");
			} else {
				return ThemeManager.Get("Player/top/base05_combat_shotgun.png");
			}
		}
		
		public function GetUpgradeIcon():BitmapData {
			if (!collected) {
				return ThemeManager.Get("WeaponIcons/w04_shotgun.png");
			} else if(!upgraded) {
				return ThemeManager.Get("WeaponIcons/w05_combat_shotgun.png");
			}
			
			return null;
		}
		
		public function ReportKills(newKills:int):void {
			totalKills += newKills;
			
			if (totalKills > 150) {
				TrophyHelper.GotTrophyByName("Boomstick");
			}
		}
		
		public function ReportStatistics():void {
			Stats.SetHighestInt("ShotgunKillsHigh", totalKills);
			Stats.AddValue("ShotgunKillsTotal", totalKills);
		}
		
	}

}