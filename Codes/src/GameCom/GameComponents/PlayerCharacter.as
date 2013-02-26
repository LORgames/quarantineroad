package GameCom.GameComponents 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	import flash.ui.Keyboard;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.WorldManager;
	import LORgames.Engine.Keys;
	/**
	 * ...
	 * @author Paul
	 */
	public class PlayerCharacter extends Sprite {
		private var body:b2Body;
		private var animation:AnimatedSprite = new AnimatedSprite();
		
		private var MOVEMENT_SPEED:Number = 10;
		
		private var quotes:Array = ["I don't have pet peeves, I have whole kennels of irritation.", "Normal is nothing more than a cycle on a washing machine.", "When you are kind to someone in trouble, you hope they'll remember and be kind to someone else. And it'll become like a wildfire.", "We're here for a reason. I believe a bit of the reason is to throw little torches out to lead people through the dark."];
		
		private var showQuote:int = -1;
		private var quoteTimeout:Number = 10;
		
		public function PlayerCharacter() {
			//animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie/0_0.png"));
			animation.AddFrame(ThemeManager.Get("Player/Goldberg.png"));
			animation.ChangePlayback(0.5, 0, 1);
			
			this.addChild(animation);
			
			//Create the defintion
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.userData = this;
			bodyDef.allowSleep = false;
			bodyDef.position = new b2Vec2(0, 500 / Global.PHYSICS_SCALE);
			
			var fixture:b2FixtureDef = new b2FixtureDef();
			fixture.restitution = 0;
			fixture.friction = 0;
			fixture.shape = new b2CircleShape(0.6);
			fixture.userData = this;
			fixture.density = 0.1;
			
			body = WorldManager.World.CreateBody(bodyDef);
			body.CreateFixture(fixture);
			body.SetFixedRotation(true);
			
			body.SetLinearDamping(0.5);
		}
		
		public function Update(dt:Number):void {
			animation.Update(dt);
			
			animation.x = -animation.width / 2;
			animation.y = -animation.height + 0.6 * Global.PHYSICS_SCALE;
			
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
			
			var xSpeed:Number = 0;
			var ySpeed:Number = 0;
			
			if (Keys.isKeyDown(Keyboard.W) || Keys.isKeyDown(Keyboard.UP)) {
				ySpeed = -1;
			} else if (Keys.isKeyDown(Keyboard.S) || Keys.isKeyDown(Keyboard.DOWN)) {
				ySpeed = 1;
			}
			
			if (Keys.isKeyDown(Keyboard.A) || Keys.isKeyDown(Keyboard.LEFT)) {
				xSpeed = -1;
			} else if (Keys.isKeyDown(Keyboard.D) || Keys.isKeyDown(Keyboard.RIGHT)) {
				xSpeed = 1;
			}
			
			body.SetLinearVelocity(new b2Vec2(xSpeed * MOVEMENT_SPEED, ySpeed * MOVEMENT_SPEED));
			
			quoteTimeout -= dt;
			if (quoteTimeout < 0 && showQuote == -1) {
				showQuote = Math.random() * quotes.length;
				quoteTimeout = 5;
			} else if (quoteTimeout < 0) {
				showQuote = -1;
				quoteTimeout = Math.random() * 25 + 5;
			}
			
			if (showQuote != -1) {
				GUIManager.I.ShowTooltipAt(this.x, this.y - animation.height, quotes[showQuote]);
			}
		}
		
	}

}