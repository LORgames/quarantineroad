package GameCom.GameComponents.Weapons {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.ui.Keyboard;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.GameComponents.Zombies.IZombie;
	import GameCom.Managers.BulletManager;
	import GameCom.Managers.WorldManager;
	import LORgames.Engine.Keys;
	/**
	 * ...
	 * @author Paul
	 */
	public class LaserGun implements IWeapon {
		
		private var safeFixtures:Vector.<b2Body> = new Vector.<b2Body>();
		
		public var CHARGE_TIME:Number = 0.5;
		public var charge:Number = 0;
		
		private var Layer:Sprite;
		
		private var objectHit:b2Fixture;
		private var pointHit:b2Vec2;
		
		private var isActive:Boolean = false;
		
		private var battery:Number = 10;
		
		public function LaserGun(body:b2Body, layer:Sprite) {
			this.Layer = layer;
			AddSafe(body);
		}
		
		/* INTERFACE GameCom.GameComponents.Weapons.IWeapon */
		
		public function Update(dt:Number, location:b2Vec2):void {
			if (Keys.isKeyDown(Keyboard.SPACE) && battery > 0) {
				charge += dt;
				
				if (charge > CHARGE_TIME) {
					charge = CHARGE_TIME;
					
					battery -= dt;
					if (battery < 0) battery = 0;
					
					objectHit = null;
					pointHit = new b2Vec2(location.x, 0);
					WorldManager.World.RayCast(RCCallback, location, pointHit);
					
					Layer.graphics.clear();
					Layer.graphics.beginBitmapFill(ThemeManager.Get("bullets/Laser00.png"), new Matrix(1, 0, 0, 1, int(location.x * Global.PHYSICS_SCALE) - 3, 0));
					Layer.graphics.drawRect(int(pointHit.x * Global.PHYSICS_SCALE) - 2, int(pointHit.y * Global.PHYSICS_SCALE) - 20, 6, (location.y - pointHit.y) * Global.PHYSICS_SCALE + 20);
					Layer.graphics.endFill();
					
					if(objectHit != null) {
						if (objectHit.GetUserData() is IZombie) {
							(objectHit.GetUserData() as IZombie).Hit(0.25);
						}
					}
				}
			} else {
				charge = 0;
				Layer.graphics.clear();
			}
		}
		
		private function RCCallback(fixture:b2Fixture, point:b2Vec2, normal:b2Vec2, fraction:Number):Number {
			if (!fixture.IsSensor() && pointHit.y < point.y) {
				pointHit = point;
				objectHit = fixture;
				return fraction;
			}
			
			return 1.0;
		}
		
		public function Upgrade():void {
			CHARGE_TIME = 0.1;
		}
		
		public function GetAmmoReadout():String {
			return battery.toFixed(1);
		}
		
		public function AddAmmo():void {
			battery += Math.random() * 4 + 1;
		}
		
		public function Activate():void {
			isActive = true;
		}
		
		public function Deactivate():void {
			isActive = false
			charge = 0;
			Layer.graphics.clear();
		}
		
		public function IsActive():Boolean {
			return isActive;
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
			return ThemeManager.Get("WeaponIcons/w07_laser.png");
		}
		
		public function GetPlayerBody():BitmapData {
			return ThemeManager.Get("Player/top/base07_laser.png");
		}
		
		public function GetUpgradeIcon():BitmapData {
			return null;
		}
		
		public function ReportKills(newKills:int):void {}
	}

}