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
	import GameCom.SystemComponents.Stat;
	import GameCom.SystemComponents.TrophyToast;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import LORgames.Engine.Stats;
	/**
	 * ...
	 * @author Paul
	 */
	public class BasicGun implements IWeapon {
		private var MAX_AMMO:int = int.MAX_VALUE; //LOLOLOLOL TOO MANY AMMO.
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		private var totalKills:int = 0;
		
		public var isUpgraded:Boolean = false;
		public var FIRE_RATE:Number = 0.4;
		public var fireTime:Number = 0;
		
		public var firedLeft:Boolean = true;
		
		public function BasicGun(body:b2Body) {
			AddSafe(body);
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2):Boolean {
			if (fireTime > FIRE_RATE) {
				if(Keys.isKeyDown(32)) {
					fireTime -= FIRE_RATE;
					
					if(firedLeft || !isUpgraded) {
						BulletManager.I.FireAt(location, BasicBullet, this);
					} else {
						BulletManager.I.FireAt(new b2Vec2(location.x - 0.6, location.y), BasicBullet, this);
					}
					
					firedLeft = !firedLeft;
					
					AudioController.PlaySound(AudioStore.Pistol1);
				}
			} else {
				fireTime += dt;
			}
			
			return true;
		}
		
		public function Upgrade():void {
			isUpgraded = true;
			FIRE_RATE = 0.3;
			TrophyHelper.GotTrophyByName("2 for 1");
			
			TrophyToast.I.AddWeaponPickup("Dual Pistols", ThemeManager.Get("WeaponIcons/w01_dual_pistol.png"));
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
			if(!isUpgraded) {
				return ThemeManager.Get("WeaponIcons/w00_pistol.png");
			} else {
				return ThemeManager.Get("WeaponIcons/w01_dual_pistol.png");
			}
		}
		
		public function GetPlayerBody():BitmapData {
			if(!isUpgraded) {
				return ThemeManager.Get("Player/top/base00_pistol.png");
			} else {
				return ThemeManager.Get("Player/top/base01_dual_pistol.png");
			}
		}
		
		public function GetUpgradeIcon():BitmapData {
			if (!isUpgraded) {
				return ThemeManager.Get("WeaponIcons/w01_dual_pistol.png");
			}
			
			return null;
		}
		
		public function ReportKills(newKills:int):void {
			totalKills += newKills;
		}
		
		public function ReportStatistics():void {
			Stats.SetHighestInt("PistolKillsHigh", totalKills);
			Stats.AddValue("PistolKillsTotal", totalKills);
		}
		
	}

}