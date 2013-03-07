package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.BitmapData;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.Helpers.AudioStore;
	import GameCom.Managers.BulletManager;
	import GameCom.Managers.GUIManager;
	import LORgames.Engine.AudioController;
	/**
	 * ...
	 * @author Paul
	 */
	public class Shotgun implements IWeapon {
		
		public const RANGE:Number = 5;
		public const DAMAGE:Number = 10;
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		public var FIRE_RATE:Number = 0.5;
		public var fireTime:Number = 0;
		
		private var upgraded:Boolean = false;
		private var shells:int = 10;
		
		public function Shotgun(body:b2Body) {
			AddSafe(body);
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2):void {
			fireTime += dt;
			
			if (fireTime > FIRE_RATE) {
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
		}
		
		
		public function Upgrade():void {
			upgraded = true;
			FIRE_RATE = 0.5;
			GUIManager.I.RedrawWeapons();
		}
		
		public function AddAmmo():void {
			shells += 25;
		}
		
		private var isActive:Boolean = false;
		public function Activate():void { isActive = true; }
		public function Deactivate():void { isActive = false; }
		public function IsActive():Boolean { return isActive; }
		
		public function GetAmmoReadout():String {
			return shells.toString();
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
			if(!upgraded) {
				return ThemeManager.Get("WeaponIcons/w04_shotgun.png");
			} else {
				return ThemeManager.Get("WeaponIcons/w05_combat_shotgun.png");
			}
		}
		
		public function GetUpgradeIcon():BitmapData {
			if(!upgraded) {
				return ThemeManager.Get("WeaponIcons/w05_combat_shotgun.png");
			}
			
			return null;
		}
		
	}

}