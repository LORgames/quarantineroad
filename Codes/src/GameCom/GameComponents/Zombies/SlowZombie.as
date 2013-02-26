package GameCom.GameComponents.Zombies 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.WorldManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class SlowZombie extends Sprite implements IZombie {
		private const BASE_HP:Number = 5.0;
		
		private var body:b2Body;
		private var myHP:Number = 5.0;
		
		private var animation:AnimatedSprite = new AnimatedSprite();
		private var eyes:AnimatedSprite = new AnimatedSprite();
		
		private var MOVEMENT_SPEED:Number = 2.5;
		
		private var quotes:Array = ["...", "BRAAAAAAIIIIINNNNNS"];
		
		private var showQuote:int = -1;
		private var quoteTimeout:Number = 10;
		
		public function SlowZombie() {
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie/0_0.png"));
			animation.ChangePlayback(0.5, 0, 1);
			this.addChild(animation);
			
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
			fixture.filter.categoryBits = Global.PHYSCAT_ZOMBIES;
			fixture.filter.maskBits = 0xffff & ~Global.PHYSCAT_WALLS;
			fixture.userData = this;
			
			body = WorldManager.World.CreateBody(bodyDef);
			body.CreateFixture(fixture);
			body.SetFixedRotation(true);
			
			body.SetLinearDamping(0.5);
		}
		
		public function Update(dt:Number):void {
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
			
			animation.Update(dt);
			animation.x = -animation.width / 2;
			animation.y = -animation.height + 0.6 * Global.PHYSICS_SCALE;
			
			eyes.x = this.x - eyes.width / 2;
			eyes.y = this.y - eyes.height + 0.6 * Global.PHYSICS_SCALE;
			
			var xSpeed:Number = 0;
			var ySpeed:Number = 1;
			
			//TODO: Logic to set X and Y speeds
			
			if(dt > 0) body.SetLinearVelocity(new b2Vec2(xSpeed * MOVEMENT_SPEED, ySpeed * MOVEMENT_SPEED));
			
			quoteTimeout -= dt;
			if (quoteTimeout < 0 && showQuote == -1) {
				showQuote = Math.random() * quotes.length;
				quoteTimeout = 5;
			} else if (quoteTimeout < 0) {
				showQuote = -1;
				quoteTimeout = Math.random() * 25 + 5;
			}
			
			if (showQuote != -1) {
				GUIManager.I.ShowTooltipAt(body.GetPosition().x * Global.PHYSICS_SCALE, body.GetPosition().y * Global.PHYSICS_SCALE - animation.height, quotes[showQuote]);
			}
		}
		
		public function Hit(damage:Number):void {
			myHP -= damage;
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
			
			showQuote = -1;
			quoteTimeout = Math.random() * 30;
			
			body.SetActive(true);
			
			body.SetPosition(position);
			
			myHP = BASE_HP;
			
			Update(0);
		}
		
		public function RemoveFromScene(layer0:Sprite, layer1:Sprite):void {
			layer0.removeChild(this);
			layer1.removeChild(eyes);
			
			body.SetActive(false);
		}
		
	}

}