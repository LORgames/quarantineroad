package GameCom.GameComponents.Zombies 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Helpers.MathHelper;
	import GameCom.Managers.ExplosionManager;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.LootManager;
	import GameCom.Managers.WorldManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class ExplosionZombie extends Sprite implements IZombie {
		private const BASE_HP:Number = 3.0;
		
		private var body:b2Body;
		
		private var isDead:Boolean = false;
		private var myHP:Number = 3.0;
		private var mySpeed:Number = 1;
		
		private var animation:AnimatedSprite = new AnimatedSprite();
		private var eyes:AnimatedSprite = new AnimatedSprite();
		
		private var quotes:Array = ["My mama's so fat she still calls me bite size :'("];
		
		private var showQuote:int = -1;
		private var quoteTimeout:Number = 10;
		
		public function ExplosionZombie() {
			animation.AddFrame(ThemeManager.Get("Zombies/ExplosionZombie/0_0.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/ExplosionZombie/0_1.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/ExplosionZombie/0_2.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/ExplosionZombie/0_3.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/ExplosionZombie/0_4.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/ExplosionZombie/0_5.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/ExplosionZombie/0_6.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/ExplosionZombie/0_7.png"));
			animation.ChangePlayback(0.1, 0, 8);
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
			fixture.shape = new b2CircleShape(0.9);
			fixture.userData = this;
			fixture.density = 1.0;
			fixture.filter.categoryBits = Global.PHYSICS_CATEGORY_ZOMBIES;
			fixture.filter.maskBits = 0xffff & ~Global.PHYSICS_CATEGORY_WALLS;
			fixture.userData = this;
			
			body = WorldManager.World.CreateBody(bodyDef);
			body.CreateFixture(fixture);
			body.SetFixedRotation(true);
			
			body.SetLinearDamping(0.5);
		}
		
		public function Update(dt:Number):void {
			this.x = Math.round(body.GetPosition().x * Global.PHYSICS_SCALE);
			this.y = Math.round(body.GetPosition().y * Global.PHYSICS_SCALE);
			
			animation.Update(dt);
			animation.x = -animation.width / 2;
			animation.y = -animation.height + 0.9 * Global.PHYSICS_SCALE;
			
			//eyes.Update(dt);
			//eyes.x = this.x - eyes.width / 2;
			//eyes.y = this.y - eyes.height + 0.9 * Global.PHYSICS_SCALE;
			
			var xSpeed:Number = 0;
			var ySpeed:Number = mySpeed + WorldManager.WorldScrollSpeed;
			
			//TODO: Logic to set X and Y speeds
			if (this.y < WorldManager.WorldTargetY+100 && WorldManager.WorldTargetY - this.y < stage.stageHeight / 3) {
				if (this.x < WorldManager.WorldTargetX) {
					xSpeed = 1;
				} else {
					xSpeed = -1;
				}
			}
			
			if (MathHelper.DistanceSquared(new Point(this.x, this.y), new Point(WorldManager.WorldTargetX, WorldManager.WorldTargetY)) < 5000) {
				ExplosionManager.I.RequestExplosionAt(new Point(this.x, this.y));
				myHP = -1;
			}
			
			if(dt > 0) body.SetLinearVelocity(new b2Vec2(xSpeed, ySpeed));
			
			quoteTimeout -= dt;
			if (quoteTimeout < 0 && showQuote == -1) {
				showQuote = Math.random() * quotes.length;
				quoteTimeout = 5;
			} else if (quoteTimeout < 0) {
				showQuote = -1;
				quoteTimeout = Math.random() * 25 + 5;
			}
			
			if (showQuote != -1) {
				//GUIManager.I.ShowTooltipAt(body.GetPosition().x * Global.PHYSICS_SCALE, body.GetPosition().y * Global.PHYSICS_SCALE - animation.height, quotes[showQuote]);
			}
		}
		
		public function Hit(damage:Number):void {
			myHP -= damage;
			
			if (myHP <= 0 && !isDead) {
				isDead = true;
				ExplosionManager.I.RequestExplosionAt(new Point(this.x, this.y));
			}
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
			isDead = false;
			
			mySpeed = Math.random() / 2 + 0.75;
			
			Update(0);
		}
		
		public function RemoveFromScene(layer0:Sprite, layer1:Sprite):void {
			layer0.removeChild(this);
			layer1.removeChild(eyes);
			
			if(Math.random() < 0.001) {
				LootManager.I.SpawnLootAt(body.GetPosition());
			}
			
			body.SetActive(false);
		}
		
	}

}