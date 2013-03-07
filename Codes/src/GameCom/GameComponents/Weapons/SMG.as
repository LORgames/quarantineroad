package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.BitmapData;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.Managers.BulletManager;
	import GameCom.Managers.GUIManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class SMG implements IWeapon {
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		public var FIRE_RATE:Number = 0.1;
		public var fireTime:Number = 0;
		
		private var totalSMGs:int = 1;
		
		private var bullets:int = 250;
		
		public function SMG(body:b2Body) {
			AddSafe(body);
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2):void {
			fireTime += dt;
			
			if (fireTime > FIRE_RATE) {
				fireTime -= FIRE_RATE;
				
				for (var i:int = 0; i < totalSMGs; i++) {
					if(bullets > 0) {
						BulletManager.I.FireAt(location, BasicBullet, this, (Math.random() - 0.5), 5);
						bullets--;
					}
				}
			}
		}
		
		public function Upgrade():void {
			totalSMGs = 2;
			GUIManager.I.RedrawWeapons();
		}
		
		public function GetAmmoReadout():String {
			return bullets.toString();
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
			if(totalSMGs == 2) {
				return ThemeManager.Get("WeaponIcons/w03_dual_smg.png");
			} else {
				return ThemeManager.Get("WeaponIcons/w02_smg.png");
			}
		}
		
	}

}