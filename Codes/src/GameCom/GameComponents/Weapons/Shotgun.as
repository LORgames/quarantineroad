package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.Managers.BulletManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class Shotgun implements IWeapon {
		
		public const RANGE:Number = 5;
		public const DAMAGE:Number = 10;
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		public var FIRE_RATE:Number = 1;
		public var fireTime:Number = 0;
		
		public function Shotgun() {
			
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2):void {
			fireTime += dt;
			
			if (fireTime > FIRE_RATE) {
				fireTime -= FIRE_RATE;
				BulletManager.I.FireAt(location, BasicBullet, this,-3*Math.PI/10, RANGE, DAMAGE);
				BulletManager.I.FireAt(location, BasicBullet, this,-2*Math.PI/10, RANGE, DAMAGE);
				BulletManager.I.FireAt(location, BasicBullet, this,-1*Math.PI/10, RANGE, DAMAGE);
				BulletManager.I.FireAt(location, BasicBullet, this,-0*Math.PI/10, RANGE, DAMAGE);
				BulletManager.I.FireAt(location, BasicBullet, this, 1*Math.PI/10, RANGE, DAMAGE);
				BulletManager.I.FireAt(location, BasicBullet, this, 2*Math.PI/10, RANGE, DAMAGE);
				BulletManager.I.FireAt(location, BasicBullet, this, 3*Math.PI/10, RANGE, DAMAGE);
			}
		}
		
		public function AddAmmo():void {
			FIRE_RATE = 0.2;
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
		
	}

}