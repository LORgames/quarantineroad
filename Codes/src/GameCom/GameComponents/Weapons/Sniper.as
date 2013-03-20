package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.BitmapData;
	import flash.ui.Keyboard;
	import GameCom.GameComponents.PlayerCharacter;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.GameComponents.Projectiles.SniperBullet;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.TrophyHelper;
	import GameCom.Managers.BulletManager;
	import GameCom.SystemComponents.TrophyToast;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import LORgames.Engine.Mousey;
	import LORgames.Engine.Stats;
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
		
		private var totalKills:int = 0;
		private var longRangeKills:int = 0;
		
		public function Sniper(body:b2Body) {
			AddSafe(body);
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2, player:PlayerCharacter):Boolean {
			if (fireTime > FIRE_RATE) {
				if(player.ShouldFire() && bullets > 0) {
					fireTime -= FIRE_RATE;
					BulletManager.I.FireAt(location, SniperBullet, this);
					bullets--;
					
					AudioController.PlaySound(AudioStore.SniperFire1);
				}
			} else {
				fireTime += dt;
			}
			
			if (bullets == 0) return false;
			return true;
		}
		
		public function Upgrade():void {
			if (!collected) {
				collected = true;
				TrophyToast.I.AddWeaponPickup("Sniper Rifle", ThemeManager.Get("WeaponIcons/w06_sniper.png"));
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
		
		public function IsMaxAmmo():Boolean {
			return (bullets == MAX_AMMO);
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
		
		public function ReportKills(newKills:int):void {
			totalKills += newKills;
		}
		
		public function LongRange():void {
			longRangeKills++;
			if(longRangeKills > 25) TrophyHelper.GotTrophyByName("Headshot");
		}
		
		public function ReportStatistics():void {
			Stats.SetHighestInt("SniperKillsHigh", totalKills);
			Stats.AddValue("SniperKillsTotal", totalKills);
		}
		
	}

}