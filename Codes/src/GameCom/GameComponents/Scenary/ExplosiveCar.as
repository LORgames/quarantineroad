package GameCom.GameComponents.Scenary 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GameCom.GameComponents.PlayerCharacter;
	import GameCom.GameComponents.Zombies.IZombie;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Helpers.ScoreHelper;
	import GameCom.Managers.ExplosionManager;
	import GameCom.Managers.LootManager;
	import GameCom.Managers.WorldManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class ExplosiveCar extends Sprite implements IZombie {
		
		private var art:AnimatedSprite = new AnimatedSprite();
		private var currentHP:int = -1;
		
		private var isDead:Boolean = false;
		private var body:b2Body;
		
		private static var IDN:int = 0;
		private var myID:int = 0;
		
		public function ExplosiveCar(carid:int) {
			myID = IDN++;
			
			art.AddFrame(ThemeManager.Get("ExplosiveCars/car0" + carid + "-00.png"));
			art.AddFrame(ThemeManager.Get("ExplosiveCars/car0" + carid + "-01.png"));
			art.AddFrame(ThemeManager.Get("ExplosiveCars/car0" + carid + "-02.png"));
			
			art.ChangePlayback(0.1, 0, 1, true);
			art.Update(0);
			
			art.x = -art.width / 2 + 8;
			art.y = -art.height / 2 - 28;
			
			this.addChild(art);
			
			//Create the defintion
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.userData = this;
			bodyDef.allowSleep = false;
			bodyDef.position = new b2Vec2(5, -100 / Global.PHYSICS_SCALE);
			bodyDef.userData = this;
			bodyDef.fixedRotation = true;
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsOrientedBox(0.9, 2.4, new b2Vec2(), -0.9);
			
			var fixture:b2FixtureDef = new b2FixtureDef();
			fixture.restitution = 0;
			fixture.friction = 0;
			fixture.shape = shape;
			fixture.userData = this;
			fixture.density = 0.1;
			fixture.filter.categoryBits = Global.PHYSICS_CATEGORY_ZOMBIES;
			fixture.filter.maskBits = 0xffff & ~Global.PHYSICS_CATEGORY_WALLS;
			fixture.userData = this;
			
			body = WorldManager.World.CreateBody(bodyDef);
			body.CreateFixture(fixture);
			body.SetFixedRotation(true);
			body.SetLinearDamping(0.5);
			body.SetActive(false);
		}
		
		public function Update(dt:Number):void {
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
			
			body.SetLinearVelocity(new b2Vec2(0, WorldManager.WorldScrollSpeed));
		}
		
		public function Hit(damage:Number):Boolean {
			currentHP -= damage;
			
			if (currentHP <= 0) {
				if(!isDead) {
					isDead = true;
					ExplosionManager.I.RequestCarExplosionAt(new Point(this.x, this.y));
					LootManager.I.SpawnWeaponAt(body.GetPosition());
					this.body.SetActive(false);
				}
			} else if (currentHP <= 5) {
				art.ChangePlayback(0.1, 2, 1, true);
			} else if (currentHP <= 10) {
				art.ChangePlayback(0.1, 1, 1, true);
			}
			
			art.Update(0);
			
			return false; //The kill never counts for cars
		}
		
		public function HitPlayer(player:PlayerCharacter):Number {
			return 0;
		}
		
		public function OutsideScene():Boolean {
			if (!body.IsActive()) { 
				return true;
			} else if (body.GetPosition().y > stage.stageHeight / Global.PHYSICS_SCALE + 2) {
				return true;
			}
			
			return false;
		}
		
		public function AddToScene(position:b2Vec2, layer0:Sprite, layer1:Sprite):void {
			isDead = false;
			body.SetPosition(position);
			body.SetActive(true);
			
			if (ScoreHelper.Time.Value < 60) {
				currentHP = 3;
			} else {
				currentHP = 5 + int(10*Math.random());
			}
			
			art.ChangePlayback(0.1, 0, 1, true);
			art.Update(0);
		}
		
		public function RemoveFromScene(layer0:Sprite, layer1:Sprite):void {
			
		}
		
		public function GetPixelLocation():Point {
			return new Point(this.x, this.y);
		}
		
	}

}