package GameCom.GameComponents.Weapons {
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.WeakFunctionClosure;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import GameCom.GameComponents.Decorations.Lightning;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.GameComponents.Zombies.IZombie;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.TrophyHelper;
	import GameCom.Managers.BulletManager;
	import GameCom.Managers.WorldManager;
	import GameCom.SystemComponents.TrophyToast;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import LORgames.Engine.Stats;
	/**
	 * ...
	 * @author Paul
	 */
	public class ChainLightningGun implements IWeapon {
		private var MAX_AMMO:int = 20; //LOLOLOLOL TOO MANY AMMO.
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		public var FIRE_RATE:Number = 0.1;
		public var fireTime:Number = 0;
		
		public var fried:Vector.<IZombie>;
		
		private var collected:Boolean = false;
		private var battery:Number = 3.0;
		
		private var lightning:Lightning = new Lightning();
		
		private var totalKills:int = 0;
		
		public function ChainLightningGun(body:b2Body, layer:Sprite) {
			AddSafe(body);
			layer.addChild(lightning);
			lightning.visible = false;
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2):Boolean {
			if (fireTime > FIRE_RATE) {
				if (battery > 0 && (Keys.isKeyDown(Keyboard.SPACE) || Keys.isKeyDown(Keyboard.NUMPAD_ENTER)) && collected) {
					fireTime -= FIRE_RATE;
					
					fried = new Vector.<IZombie>();
					WorldManager.World.QueryShape(QueryZombie, new b2CircleShape(5), new b2Transform(location, new b2Mat22()));
					
					if (fried.length > 0) {
						battery -= FIRE_RATE;
						
						AudioController.PlaySound(AudioStore.ChainLightningGun1);
					}
					
					//LIGHTNING
					var points:Vector.<Point> = new Vector.<Point>();
					points.push(new Point(location.x * Global.PHYSICS_SCALE, location.y * Global.PHYSICS_SCALE));
					
					for (var i:int = 0; i < Math.min(3, fried.length); i++) {
						if (fried[i].Hit(0.5)) {
							ReportKills(1);
						}
						points.push(fried[i].GetPixelLocation());
					}
					
					lightning.DrawPoints(points);
				}
			} else {
				fireTime += dt;
			}
			
			lightning.Update(dt);
			
			if (battery == 0) return false;
			
			return true;
		}
		
		public function QueryZombie(fixture:b2Fixture):Boolean {
			if (fixture.GetUserData() is IZombie) {
				fried.push(fixture.GetUserData() as IZombie);
			}
			
			return true;
		}
		
		public function Upgrade():void {
			if (!collected) {
				collected = true;
				TrophyToast.I.AddWeaponPickup("Tesla Rifle", ThemeManager.Get("WeaponIcons/w11_chain_lightning.png"));
			}
		}
		
		public function GetAmmoReadout():String {
			if (!collected) {
				return "";
			} else if(battery > Number.MIN_VALUE*5) {
				return battery.toFixed(1);
			} else {
				return "0.0";
			}
		}
		
		public function Activate():void {
			lightning.visible = true;
		}
		
		public function Deactivate():void {
			lightning.visible = false;
		}
		
		public function IsActive():Boolean {
			return lightning.visible;
		}
		
		public function AddAmmo():void {
			if(collected) battery += Math.random() * 2 + 2;
			if (battery > MAX_AMMO) battery = MAX_AMMO;
		}
		
		public function IsMaxAmmo():Boolean {
			return (battery == MAX_AMMO);
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
			if (collected) return ThemeManager.Get("WeaponIcons/w11_chain_lightning.png");
			return null;
		}
		
		public function GetPlayerBody():BitmapData {
			if (collected) return ThemeManager.Get("Player/top/base11_chain_lightning.png");
			return ThemeManager.Get("Player/top/base.png");
		}
		
		public function GetUpgradeIcon():BitmapData {
			if (!collected) return ThemeManager.Get("WeaponIcons/w11_chain_lightning.png");
			return null;
		}
		
		public function ReportKills(newKills:int):void {
			totalKills += newKills;
			
			if (totalKills > 200) {
				TrophyHelper.GotTrophyByName("Tesla's Pride");
			}
		}
		
		public function ReportStatistics():void {
			Stats.SetHighestInt("LightningKillsHigh", totalKills);
			Stats.AddValue("LightningKillsTotal", totalKills);
		}
		
	}

}