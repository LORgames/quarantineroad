package GameCom.GameComponents.Zombies 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import GameCom.GameComponents.PlayerCharacter;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Managers.BGManager;
	import GameCom.Managers.ExplosionManager;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.LootManager;
	import GameCom.Managers.WorldManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class RedZombie extends Sprite implements IZombie {
		private const BASE_HP:Number = 1.0;
		private const SCORE:int = 1;
		
		private var body:b2Body;
		
		private var myHP:Number = 1;
		private var mySpeed:Number = 1;
		private var dead:Boolean = false;
		
		private var animation:AnimatedSprite = new AnimatedSprite();
		private var eyes:AnimatedSprite = new AnimatedSprite();
		
		public function RedZombie() {
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie Red/1.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie Red/2.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie Red/3.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie Red/4.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie Red/5.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie Red/6.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie Red/7.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie Red/8.png"));
			animation.ChangePlayback(0.3333, 0, 8);
			this.addChild(animation);
			
			eyes.AddFrame(ThemeManager.Get("Zombies/Base Zombie/Eyes.png"));
			eyes.ChangePlayback(0.5, 0, 1);
			eyes.Update(0);
			
			//Create the defintion
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.userData = this;
			bodyDef.allowSleep = false;
			bodyDef.position = new b2Vec2(0, -100 / Global.PHYSICS_SCALE);
			bodyDef.userData = this;
			
			var fixture:b2FixtureDef = new b2FixtureDef();
			fixture.restitution = 0;
			fixture.friction = 0;
			fixture.shape = new b2CircleShape(0.6);
			fixture.userData = this;
			fixture.density = 0.1;
			fixture.filter.categoryBits = Global.PHYSICS_CATEGORY_ZOMBIES;
			fixture.filter.maskBits = 0xffff & ~Global.PHYSICS_CATEGORY_WALLS;
			fixture.userData = this;
			
			body = WorldManager.World.CreateBody(bodyDef);
			body.CreateFixture(fixture);
			body.SetFixedRotation(true);
			body.SetActive(false);
			
			body.SetLinearDamping(0.5);
		}
		
		public function Update(dt:Number):void {
			this.x = Math.round(body.GetPosition().x * Global.PHYSICS_SCALE);
			this.y = Math.round(body.GetPosition().y * Global.PHYSICS_SCALE);
			
			animation.Update(dt);
			animation.x = -animation.width / 2;
			animation.y = -animation.height + 0.6 * Global.PHYSICS_SCALE;
			
			eyes.Update(dt);
			eyes.x = this.x - eyes.width / 2;
			eyes.y = this.y - eyes.height + 0.6 * Global.PHYSICS_SCALE;
			
			var xSpeed:Number = 0;
			var ySpeed:Number = mySpeed + WorldManager.WorldScrollSpeed;
			
			//TODO: Logic to set X and Y speeds
			if (this.y < WorldManager.WorldTargetY+100 && WorldManager.WorldTargetY - this.y < stage.stageHeight / 3) {
				if (this.x < WorldManager.WorldTargetX) {
					xSpeed = 1.25;
				} else {
					xSpeed = -1.25;
				}
			}
			
			if(dt > 0) body.SetLinearVelocity(new b2Vec2(xSpeed, ySpeed));
		}
		
		public function Hit(damage:Number):void {
			myHP -= damage;
			
			if (myHP <= 0 && !dead) {
				dead = true;
				GUIManager.I.UpdateScore(SCORE);
				
				if(Math.random() < 0.001) {
					LootManager.I.SpawnLootAt(body.GetPosition());
				}
				
				BGManager.I.AddBloodSplatter(this.x, this.y, true);
			}
		}
		
		public function HitPlayer(player:PlayerCharacter):Number {
			Hit(myHP);
			return 1;
		}
		
		public function Move(newPosition:b2Vec2):void {
			
		}
		
		public function OutsideScene():Boolean {
			if (myHP <= 0) {
				return true;
			}
			
			if (this.y - animation.height > animation.stage.stageHeight) {
				return true;
			}
			
			return false;
		}
		
		public function AddToScene(position:b2Vec2, layer0:Sprite, layer1:Sprite):void {
			layer0.addChild(this);
			layer1.addChild(eyes);
			
			body.SetActive(true);
			body.SetPosition(position);
			
			myHP = BASE_HP;
			dead = false;
			
			mySpeed = Math.random() + 7.5;
			
			Update(0);
		}
		
		public function RemoveFromScene(layer0:Sprite, layer1:Sprite):void {
			body.SetPosition(new b2Vec2(0, -200));
			layer0.removeChild(this);
			layer1.removeChild(eyes);
			
			body.SetActive(false);
		}
		
		public function GetPixelLocation():Point {
			return new Point(this.x, this.y);
		}
		
	}

}