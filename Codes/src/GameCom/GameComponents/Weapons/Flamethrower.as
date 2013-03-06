package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.BitmapData;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.Managers.BulletManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class Flamethrower implements IWeapon {
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		public var FIRE_RATE:Number = 0.1;
		public var fireTime:Number = 0;
		
		public function Flamethrower(body:b2Body) {
			AddSafe(body);
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2):void {
			fireTime += dt;
			
			if (fireTime > FIRE_RATE) {
				fireTime -= FIRE_RATE;
				
				//FIRE
			}
		}
		
		public function Upgrade():void {
			
		}
		
		public function GetAmmoReadout():String {
			return "INF";
		}
		
		public function AddAmmo():void {
			FIRE_RATE = 0.2;
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
			return ThemeManager.Get("WeaponIcons/w10_flame_thrower.png");
		}
		
	}

}