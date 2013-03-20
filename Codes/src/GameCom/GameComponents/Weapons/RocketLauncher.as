package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.BitmapData;
	import flash.ui.Keyboard;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.GrenadeHelper;
	import GameCom.Helpers.TrophyHelper;
	import GameCom.Managers.BulletManager;
	import GameCom.SystemComponents.TrophyToast;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import LORgames.Engine.Stats;
	/**
	 * ...
	 * @author Paul
	 */
	public class RocketLauncher implements IWeapon {
		private var MAX_AMMO:int = 15; //LOLOLOLOL TOO MANY AMMO.
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		public var FIRE_RATE:Number = 1.5;
		public var fireTime:Number = 1.5;
		
		private var collected:Boolean = false;
		private var upgraded:Boolean = false;
		
		private var totalKills:int = 0;
		private var grenades:int = 5;
		
		public function RocketLauncher(body:b2Body) {
			AddSafe(body);
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2):Boolean {
			if (fireTime > FIRE_RATE) {
				if((Keys.isKeyDown(Keyboard.SPACE) || Keys.isKeyDown(Keyboard.NUMPAD_ENTER)) && grenades > 0) {
					fireTime -= FIRE_RATE;
					
					if (!upgraded) {
						GrenadeHelper.I.SpawnGrenade(location.x * Global.PHYSICS_SCALE, location.y * Global.PHYSICS_SCALE, this);
						AudioController.PlaySound(AudioStore.GrenadeLauncher1);
					} else {
						GrenadeHelper.I.SpawnRocket(location.x * Global.PHYSICS_SCALE, location.y * Global.PHYSICS_SCALE, this);
					}
					
					grenades--;
				}
			} else {
				fireTime += dt;
			}
			
			if (grenades == 0) return false;
			return true;
		}
		
		public function Upgrade():void {
			if (!collected) {
				TrophyToast.I.AddWeaponPickup("Grenade Launcher", ThemeManager.Get("WeaponIcons/w09_grenade_launcher.png"));
				collected = true;
			} else if (!upgraded) {
				TrophyToast.I.AddWeaponPickup("Rocket Launcher", ThemeManager.Get("WeaponIcons/w15_rocketpoop.png"));
				upgraded = true;
			}
		}
		
		public function GetAmmoReadout():String {
			if (collected) return grenades.toString();
			return "";
		}
		
		public function AddAmmo():void {
			grenades += 3;
			if (grenades > MAX_AMMO) grenades = MAX_AMMO;
		}
		
		public function IsMaxAmmo():Boolean {
			return (grenades == MAX_AMMO);
		}
		
		private var isActive:Boolean = false;
		public function Activate():void { isActive = true; }
		public function Deactivate():void { isActive = false; }
		public function IsActive():Boolean { return isActive; }
		
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
			if (upgraded) return ThemeManager.Get("WeaponIcons/w15_rocketpoop.png");
			if (collected) return ThemeManager.Get("WeaponIcons/w09_grenade_launcher.png");
			return null;
		}
		
		public function GetPlayerBody():BitmapData {
			if (upgraded) return ThemeManager.Get("Player/top/base12_rocket_launcher.png");
			if (collected) return ThemeManager.Get("Player/top/base09_grenade_launcher.png");
			return ThemeManager.Get("Player/top/base.png");
		}
		
		public function GetUpgradeIcon():BitmapData {
			if (!collected) return ThemeManager.Get("WeaponIcons/w09_grenade_launcher.png");
			if (!upgraded) return ThemeManager.Get("WeaponIcons/w15_rocketpoop.png");
			return null;
		}
		
		public function ReportKills(newKills:int):void {
			totalKills += newKills;
			
			if (totalKills >= 50) {
				TrophyHelper.GotTrophyByName("Fire in the Hole");
			}
		}
		
		public function ReportStatistics():void {
			Stats.SetHighestInt("RocketKillsHigh", totalKills);
			Stats.AddValue("RocketKillsTotal", totalKills);
		}
		
	}

}