package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.BitmapData;
	import flash.ui.Keyboard;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.GameComponents.Projectiles.FlameProjectile;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.TrophyHelper;
	import GameCom.Managers.BulletManager;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	/**
	 * ...
	 * @author Paul
	 */
	public class Flamethrower implements IWeapon {
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		public var FIRE_RATE:Number = 0.15;
		public var fireTime:Number = 0;
		
		private var collected:Boolean = false;
		
		private var totalKills:int = 0;
		private var shots:int = 100;
		
		public function Flamethrower(body:b2Body) {
			AddSafe(body);
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2):void {
			if (fireTime >= FIRE_RATE) {
				if(Keys.isKeyDown(Keyboard.SPACE) && shots > 0 && collected) {
					fireTime -= FIRE_RATE;
					BulletManager.I.FireAt(location, FlameProjectile, this, (Math.random() - 0.5) * 0.25);
					shots--;
					
					AudioController.PlaySound(AudioStore.FlameThrower1);
				}
			} else {
				fireTime += dt;
			}
		}
		
		public function Upgrade():void {
			collected = true;
		}
		
		public function GetAmmoReadout():String {
			if (collected) return shots.toString();
			return "";
		}
		
		public function AddAmmo():void {
			shots += Math.random() * 25 + 25;
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
			if (collected) return ThemeManager.Get("WeaponIcons/w10_flame_thrower.png");
			return null;
		}
		
		public function GetPlayerBody():BitmapData {
			if (collected) return ThemeManager.Get("Player/top/base10_flame_thrower.png");
			return ThemeManager.Get("Player/top/base.png");
		}
		
		public function GetUpgradeIcon():BitmapData {
			if (!collected) return ThemeManager.Get("WeaponIcons/w10_flame_thrower.png");
			return null;
		}
		
		public function ReportKills(newKills:int):void {
			totalKills += newKills;
			
			if (totalKills >= 100) {
				TrophyHelper.GotTrophyByName("Crispy");
			}
		}
		
	}

}