package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.BitmapData;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.GameComponents.Projectiles.SniperBullet;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.TrophyHelper;
	import GameCom.Managers.BulletManager;
	import GameCom.Managers.GUIManager;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	/**
	 * ...
	 * @author Paul
	 */
	public class BasicGun implements IWeapon {
		private var MAX_AMMO:int = int.MAX_VALUE; //LOLOLOLOL TOO MANY AMMO.
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		public var FIRE_RATE:Number = 0.4;
		public var fireTime:Number = 0;
		
		public function BasicGun(body:b2Body) {
			AddSafe(body);
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2):void {
			if (fireTime > FIRE_RATE) {
				if(Keys.isKeyDown(32)) {
					fireTime -= FIRE_RATE;
					BulletManager.I.FireAt(location, BasicBullet, this);
					
					AudioController.PlaySound(AudioStore.Pistol1);
				}
			} else {
				fireTime += dt;
			}
		}
		
		public function Upgrade():void {
			FIRE_RATE = 0.2;
			GUIManager.I.RedrawWeapons();
			TrophyHelper.GotTrophyByName("2 for 1");
		}
		
		public function AddAmmo():void {
			
		}
		
		public function GetAmmoReadout():String {
			return "INF";
		}
		
		public function IsMaxAmmo():Boolean {
			return true;
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
			if(FIRE_RATE > 0.3) {
				return ThemeManager.Get("WeaponIcons/w00_pistol.png");
			} else {
				return ThemeManager.Get("WeaponIcons/w01_dual_pistol.png");
			}
		}
		
		public function GetPlayerBody():BitmapData {
			if(FIRE_RATE > 0.3) {
				return ThemeManager.Get("Player/top/base00_pistol.png");
			} else {
				return ThemeManager.Get("Player/top/base01_dual_pistol.png");
			}
		}
		
		public function GetUpgradeIcon():BitmapData {
			if (FIRE_RATE > 0.3) {
				return ThemeManager.Get("WeaponIcons/w01_dual_pistol.png");
			}
			
			return null;
		}
		
		public function ReportKills(newKills:int):void {}
		
	}

}