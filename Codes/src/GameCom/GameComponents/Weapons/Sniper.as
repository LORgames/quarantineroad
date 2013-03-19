package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.BitmapData;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.GameComponents.Projectiles.SniperBullet;
	import GameCom.Helpers.AudioStore;
	import GameCom.Managers.BulletManager;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	/**
	 * ...
	 * @author Paul
	 */
	public class Sniper implements IWeapon {
		private var MAX_AMMO:int = 32; //LOLOLOLOL TOO MANY AMMO.
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		private var collected:Boolean = false;
		public var FIRE_RATE:Number = 1.0;
		public var fireTime:Number = 0;
		private var bullets:int = 20;
		
		public function Sniper(body:b2Body) {
			AddSafe(body);
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2):void {
			if (fireTime > FIRE_RATE) {
				if(Keys.isKeyDown(32) && bullets > 0) {
					fireTime -= FIRE_RATE;
					BulletManager.I.FireAt(location, SniperBullet, this);
					bullets--;
					
					AudioController.PlaySound(AudioStore.SniperFire1);
				}
			} else {
				fireTime += dt;
			}
		}
		
		public function Upgrade():void {
			if (!collected) {
				collected = true;
			}
		}
		
		public function AddAmmo():void {
			if (collected) bullets += Math.random() * 3 + 3;
			
			if (bullets > MAX_AMMO) bullets = MAX_AMMO;
		}
		
		public function GetAmmoReadout():String {
			if (collected) return bullets.toString();
			return "";
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
			if (collected) return ThemeManager.Get("WeaponIcons/w06_sniper.png");
			return null;
		}
		
		public function GetPlayerBody():BitmapData {
			if(collected) {
				return ThemeManager.Get("Player/top/base06_sniper.png");
			} else {
				return ThemeManager.Get("Player/top/base.png");
			}
		}
		
		public function GetUpgradeIcon():BitmapData {
			if(!collected) return ThemeManager.Get("WeaponIcons/w06_sniper.png");
			return null;
		}
		
		public function ReportKills(newKills:int):void { }
		
	}

}