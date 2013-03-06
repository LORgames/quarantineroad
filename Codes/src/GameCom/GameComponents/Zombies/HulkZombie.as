package GameCom.GameComponents.Zombies {
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GameCom.GameComponents.IHit;
	import GameCom.GameComponents.PlayerCharacter;
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
	public class HulkZombie extends Sprite implements IZombie {
		private const BASE_HP:Number = 20.0;
		private const SCORE:int = 20;
		private const SCREENSHAKE_AMT:Number = 0.75;
		
		private const RADIUS:Number = 1.3;
		
		private var body:b2Body;
		
		private var isDead:Boolean = false;
		private var myHP:Number = 3.0;
		private var mySpeed:Number = 1;
		
		private var animation:AnimatedSprite = new AnimatedSprite();
		
		public function HulkZombie() {
			animation.AddFrame(ThemeManager.Get("Zombies/Hulk Zombie/0_0.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Hulk Zombie/0_1.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Hulk Zombie/0_2.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Hulk Zombie/0_3.png"));
			animation.ChangePlayback(0.12, 0, 4);
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
			fixture.shape = new b2CircleShape(RADIUS);
			fixture.userData = this;
			fixture.density = 100.0;
			fixture.filter.categoryBits = Global.PHYSICS_CATEGORY_ZOMBIES;
			fixture.filter.maskBits = 0xffff & ~Global.PHYSICS_CATEGORY_WALLS & ~Global.PHYSICS_CATEGORY_VOMIT;
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
			animation.y = -animation.height + RADIUS * Global.PHYSICS_SCALE;
			
			var xSpeed:Number = 0;
			var ySpeed:Number = mySpeed + WorldManager.WorldScrollSpeed;
			
			/*var contact:b2ContactEdge = body.GetContactList();
			
			while (contact != null) {
				if (contact.other.GetUserData() is IHit && !(contact.other.GetUserData() is PlayerCharacter)) {
					(contact.other.GetUserData() as IHit).Hit(2000);
				}
				
				contact = contact.next;
			}*/
			
			if(dt > 0) body.SetLinearVelocity(new b2Vec2(xSpeed, ySpeed));
		}
		
		public function Hit(damage:Number):void {
			myHP -= damage;
			
			if (myHP <= 0 && !isDead) {
				isDead = true;
				GUIManager.I.UpdateScore(SCORE);
				
				if(Math.random() < 0.001) {
					LootManager.I.SpawnLootAt(body.GetPosition());
				}
			}
		}
		
		public function HitPlayer(player:PlayerCharacter):Number {
			if(player.x < this.x) {
				player.body.ApplyImpulse(new b2Vec2(-mySpeed/2, mySpeed/2), player.body.GetWorldCenter());
			} else {
				player.body.ApplyImpulse(new b2Vec2(mySpeed/2, mySpeed/2), player.body.GetWorldCenter());
			}
			
			return 2;
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
			
			mySpeed = 4.0 + Math.random()*2;
			
			Update(0);
			
			WorldManager.WorldShake += SCREENSHAKE_AMT;
		}
		
		public function RemoveFromScene(layer0:Sprite, layer1:Sprite):void {
			body.SetPosition(new b2Vec2(0, -200));
			layer0.removeChild(this);
			body.SetActive(false);
			
			WorldManager.WorldShake -= SCREENSHAKE_AMT;
		}
		
		public function GetPixelLocation():Point {
			return new Point(this.x, this.y);
		}
		
	}

}