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
	import GameCom.GameComponents.Decorations.SqlshExplosion;
	import GameCom.GameComponents.PlayerCharacter;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Helpers.MathHelper;
	import GameCom.Helpers.ScoreHelper;
	import GameCom.Helpers.TrophyHelper;
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
		private const SCORE:int = 3;
		
		private var body:b2Body;
		
		private var isDead:Boolean = false;
		private var myHP:Number = 3.0;
		private var mySpeed:Number = 1;
		
		private var animation:AnimatedSprite = new AnimatedSprite();
		
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
			body.SetActive(false);
			
			body.SetLinearDamping(0.5);
		}
		
		public function Update(dt:Number):void {
			this.x = Math.round(body.GetPosition().x * Global.PHYSICS_SCALE);
			this.y = Math.round(body.GetPosition().y * Global.PHYSICS_SCALE);
			
			animation.Update(dt);
			animation.x = -animation.width / 2;
			animation.y = -animation.height + 0.9 * Global.PHYSICS_SCALE;
			
			var xSpeed:Number = 0;
			var ySpeed:Number = mySpeed + WorldManager.WorldScrollSpeed;
			
			if (this.y < WorldManager.WorldTargetY+100 && WorldManager.WorldTargetY - this.y < stage.stageHeight / 3) {
				if (this.x < WorldManager.WorldTargetX) {
					xSpeed = 1;
				} else {
					xSpeed = -1;
				}
			}
			
			if (MathHelper.DistanceSquared(new Point(this.x, this.y), new Point(WorldManager.WorldTargetX, WorldManager.WorldTargetY)) < 5000) {
				SqlshExplosion.RequestExplosionAt(this.x, this.y);
				myHP = -1;
			}
			
			if(dt > 0) body.SetLinearVelocityXY(xSpeed, ySpeed);
		}
		
		public function Hit(damage:Number):Boolean {
			myHP -= damage;
			
			if (myHP <= 0 && !isDead) {
				isDead = true;
				
				var kills:int = SqlshExplosion.RequestExplosionAt(this.x, this.y);
				
				ScoreHelper.Score.AddValue(SCORE);
				ScoreHelper.ExplosiveKills.AddValue(1);
				
				trace("ExplosionZombie Killed: " + kills);
				
				if (kills > 10) {
					TrophyHelper.GotTrophyByName("Party Pooper");
				}
				
				return true;
			}
			
			return false;
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
			
			body.SetActive(true);
			body.SetPosition(position);
			
			myHP = BASE_HP;
			isDead = false;
			
			mySpeed = Math.random() / 2 + 0.75;
			
			Update(0);
		}
		
		public function RemoveFromScene(layer0:Sprite, layer1:Sprite):void {
			body.SetPositionXY(Math.random()*10000, -200);
			layer0.removeChild(this);
			
			if(Math.random() < 0.001) {
				LootManager.I.SpawnAmmoAt(body.GetPosition());
			}
			
			body.SetActive(false);
		}
		
		public function GetPixelLocation():Point {
			return new Point(this.x, this.y);
		}
		
	}

}