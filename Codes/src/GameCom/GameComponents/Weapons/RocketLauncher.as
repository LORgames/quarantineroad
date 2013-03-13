package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.BitmapData;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.Helpers.GrenadeHelper;
	import GameCom.Helpers.TrophyHelper;
	import GameCom.Managers.BulletManager;
	import LORgames.Engine.Keys;
	/**
	 * ...
	 * @author Paul
	 */
	public class RocketLauncher implements IWeapon {
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		public var FIRE_RATE:Number = 1.5;
		public var fireTime:Number = 0;
		
		private var totalKills:int = 0;
		private var grenades:int = 5;
		
		public function RocketLauncher(body:b2Body) {
			AddSafe(body);
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2):void {
			if (fireTime > FIRE_RATE) {
				if(Keys.isKeyDown(32) && grenades > 0) {
					fireTime -= FIRE_RATE;
					
					GrenadeHelper.I.SpawnGrenade(location.x * Global.PHYSICS_SCALE, location.y * Global.PHYSICS_SCALE, this);
					grenades--;
				}
			} else {
				fireTime += dt;
			}
		}
		
		public function Upgrade():void {
			
		}
		
		public function GetAmmoReadout():String {
			return grenades.toString();
		}
		
		public function AddAmmo():void {
			grenades++;
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
			return ThemeManager.Get("WeaponIcons/w09_grenade_launcher.png");
		}
		
		public function GetPlayerBody():BitmapData {
			return ThemeManager.Get("Player/top/base09_grenade_launcher.png");
		}
		
		public function GetUpgradeIcon():BitmapData {
			return null;
		}
		
		public function ReportKills(newKills:int):void {
			totalKills += newKills;
			
			if (totalKills >= 100) {
				TrophyHelper.GotTrophyByName("Fire in the Hole");
			}
		}
		
	}

}