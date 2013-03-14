package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.BitmapData;
	import GameCom.GameComponents.PlayerCharacter;
	import GameCom.GameComponents.Projectiles.BasicBullet;
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
	public class SMG implements IWeapon {
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		public var FIRE_RATE:Number = 0.1;
		public var fireTime:Number = 0;
		
		private var totalSMGs:int = 1;
		
		private var bullets:int = 250;
		
		private var totalKills:int = 0;
		
		public function SMG(body:b2Body) {
			AddSafe(body);
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2):void {
			if (fireTime > FIRE_RATE) {
				if(Keys.isKeyDown(32)) {
					fireTime -= FIRE_RATE;
					
					for (var i:int = 0; i < totalSMGs; i++) {
						if(bullets > 0) {
							BulletManager.I.FireAt(location, BasicBullet, this, (Math.random() - 0.5), 5);
							bullets--;
							

						}
					}
						AudioController.PlaySound(AudioStore.SMG1);
				}
			} else {
				fireTime += dt;
			}
		}
		
		public function Upgrade():void {
			if (totalSMGs == 0) {
				totalSMGs = 1;
				GUIManager.I.RedrawWeapons();
				(safeFixtures[0].GetUserData() as PlayerCharacter).RedrawTopHalf();
			} else {
				totalSMGs = 2;
				GUIManager.I.RedrawWeapons();
				TrophyHelper.GotTrophyByName("2 for 1");
			}
		}
		
		public function GetAmmoReadout():String {
			if (totalSMGs == 0) return "";
			return bullets.toString();
		}
		
		public function AddAmmo():void {
			bullets += Math.random() * 20 + 40;
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
			} else if(totalSMGs ==1 ) {
				return ThemeManager.Get("WeaponIcons/w02_smg.png");
			} else {
				return null;
			}
		}
		
		public function GetPlayerBody():BitmapData {
			if(totalSMGs == 2) {
				return ThemeManager.Get("Player/top/base03_dual_smg.png");
			} else if(totalSMGs == 1) {
				return ThemeManager.Get("Player/top/base02_smg.png");
			} else {
				return ThemeManager.Get("Player/top/base.png");
			}
		}
		
		public function GetUpgradeIcon():BitmapData {
			if (totalSMGs == 0) {
				return ThemeManager.Get("WeaponIcons/w02_smg.png");
			} else if(totalSMGs == 1) {
				return ThemeManager.Get("WeaponIcons/w03_dual_smg.png");
			}
			
			return null;
		}
		
		public function ReportKills(newKills:int):void {
			totalKills += newKills;
			
			if (totalKills > 100) {
				TrophyHelper.GotTrophyByName("Spray and Prey");
			}
		}
		
	}

}