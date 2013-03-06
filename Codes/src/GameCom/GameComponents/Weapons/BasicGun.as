package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.BitmapData;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.GameComponents.Projectiles.SniperBullet;
	import GameCom.Managers.BulletManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class BasicGun implements IWeapon {
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		public var FIRE_RATE:Number = 0.4;
		public var fireTime:Number = 0;
		
		public function BasicGun(body:b2Body) {
			AddSafe(body);
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2):void {
			fireTime += dt;
			
			if (fireTime > FIRE_RATE) {
				fireTime -= FIRE_RATE;
				BulletManager.I.FireAt(location, BasicBullet, this);
			}
		}
		
		public function Upgrade():void {
			FIRE_RATE = 0.2;
		}
		
		public function AddAmmo():void {
			
		}
		
		public function GetAmmoReadout():String {
			return "INF";
		}
		
		public function Deactivate():void {
			
		}
		
		public function IsEmpty():Boolean {
			return false; //This weapon never runs out of ammo/time
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
			if(FIRE_RATE > 0.3) {
				return ThemeManager.Get("WeaponIcons/w00_pistol.png");
			} else {
				return ThemeManager.Get("WeaponIcons/w01_dual_pistol.png");
			}
		}
		
	}

}