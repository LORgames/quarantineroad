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
	import GameCom.GameComponents.Decorations.Lightning;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.GameComponents.Zombies.IZombie;
	import GameCom.Helpers.TrophyHelper;
	import GameCom.Managers.BulletManager;
	import GameCom.Managers.WorldManager;
	import LORgames.Engine.Keys;
	/**
	 * ...
	 * @author Paul
	 */
	public class ChainLightningGun implements IWeapon {
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		public var FIRE_RATE:Number = 0.1;
		public var fireTime:Number = 0;
		
		public var fried:Vector.<IZombie>;
		
		private var battery:Number = 3.0;
		
		private var lightning:Lightning = new Lightning();
		
		private var totalKills:int = 0;
		
		public function ChainLightningGun(body:b2Body, layer:Sprite) {
			AddSafe(body);
			layer.addChild(lightning);
			lightning.visible = false;
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2):void {
			if (fireTime > FIRE_RATE) {
				if (battery > 0 && Keys.isKeyDown(32)) {
					fireTime -= FIRE_RATE;
					
					fried = new Vector.<IZombie>();
					WorldManager.World.QueryShape(QueryZombie, new b2CircleShape(5), new b2Transform(location, new b2Mat22()));
					
					if (fried.length > 0) {
						battery -= FIRE_RATE;
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
		}
		
		public function QueryZombie(fixture:b2Fixture):Boolean {
			if (fixture.GetUserData() is IZombie) {
				fried.push(fixture.GetUserData() as IZombie);
			}
			
			return true;
		}
		
		public function Upgrade():void {
			
		}
		
		public function GetAmmoReadout():String {
			if(battery > Number.MIN_VALUE*5) {
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
			battery += Math.random() * 2 + 3;
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
			return ThemeManager.Get("WeaponIcons/w11_chain_lightning.png");
		}
		
		public function GetPlayerBody():BitmapData {
			return ThemeManager.Get("Player/top/base11_chain_lightning.png");
		}
		
		public function GetUpgradeIcon():BitmapData {
			return null;
		}
		
		public function ReportKills(newKills:int):void {
			totalKills += newKills;
			
			if (totalKills > 100) {
				TrophyHelper.GotTrophyByName("Tesla's Pride");
			}
		}
		
	}

}