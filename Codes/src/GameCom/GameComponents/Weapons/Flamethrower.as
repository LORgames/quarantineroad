package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.BitmapData;
	import flash.ui.Keyboard;
	import GameCom.GameComponents.PlayerCharacter;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.GameComponents.Projectiles.FlameProjectile;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.TrophyHelper;
	import GameCom.Managers.BulletManager;
	import GameCom.SystemComponents.TrophyToast;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import LORgames.Engine.Stats;
	/**
	 * ...
	 * @author Paul
	 */
	public class Flamethrower implements IWeapon {
		private var MAX_AMMO:int = 60; //LOLOLOLOL TOO MANY AMMO.
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		public var FIRE_RATE:Number = 0.15;
		public var fireTime:Number = 0;
		
		private var collected:Boolean = false;
		
		private var totalKills:int = 0;
		private var shots:int = 20;
		
		public function Flamethrower(body:b2Body) {
			AddSafe(body);
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2, player:PlayerCharacter):Boolean {
			if (fireTime >= FIRE_RATE) {
				if(player.ShouldFire() && shots > 0 && collected) {
					fireTime -= FIRE_RATE;
					BulletManager.I.FireAt(location, FlameProjectile, this, (Math.random() - 0.5) * 0.25);
					shots--;
					
					AudioController.PlaySound(AudioStore.FlameThrower1);
				}
			} else {
				fireTime += dt;
			}
			
			if (shots == 0) return false;
			return true;
		}
		
		public function Upgrade():void {
			collected = true;
			TrophyToast.I.AddWeaponPickup("Flame Thrower", ThemeManager.Get("WeaponIcons/w10_flame_thrower.png"));
		}
		
		public function GetAmmoReadout():String {
			if (collected) return shots.toString();
			return "";
		}
		
		public function AddAmmo():void {
			shots += Math.random() * 5 + 10;
			if (shots > MAX_AMMO) shots = MAX_AMMO;
		}
		
		public function IsMaxAmmo():Boolean {
			return (shots == MAX_AMMO);
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
			
			if (totalKills >= 250) {
				TrophyHelper.GotTrophyByName("Crispy");
			}
		}
		
		public function ReportStatistics():void {
			Stats.SetHighestInt("FireKillsHigh", totalKills);
			Stats.AddValue("FireKillsTotal", totalKills);
		}
		
	}

}