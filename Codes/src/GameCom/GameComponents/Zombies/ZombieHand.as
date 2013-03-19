package GameCom.GameComponents.Zombies {
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import GameCom.GameComponents.PlayerCharacter;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Helpers.BodyHelper;
	import GameCom.Helpers.TrophyHelper;
	import GameCom.Managers.BGManager;
	import GameCom.Managers.ExplosionManager;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.LootManager;
	import GameCom.Managers.WorldManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class ZombieHand extends Sprite implements IZombie {
		private const BASE_HP:Number = 1.0;
		private const SCORE:int = 1;
		
		private const BASE_WAIT_TIME:Number = 0.5;
		private const BASE_HURT_TIME:Number = 0.5;
		
		private const SCREENSHAKE_AMT:Number = 50.0;
		
		private const RISING:int = 0;
		private const HITING:int = 1;
		private const HURTIN:int = 2;
		private const HIDING:int = 3;
		
		private var body:b2Body;
		private var state:int = RISING;
		
		private var waitTime:Number = BASE_WAIT_TIME;
		
		private var animation:AnimatedSprite = new AnimatedSprite();
		
		public function ZombieHand() {
			animation.AddFrame(ThemeManager.Get("Zombies/Hand/0_0.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Hand/0_1.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Hand/0_2.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Hand/0_3.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Hand/0_4.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Hand/0_5.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Hand/0_6.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Hand/0_7.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Hand/0_8.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Hand/0_9.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Hand/0_10.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Hand/0_11.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Hand/0_12.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Hand/0_13.png"));
			
			this.addChild(animation);
			
			//Create the defintion
			body = BodyHelper.GetGenericCircle(0.5, Global.PHYSICS_CATEGORY_PLAYER, this, 0xffff & ~Global.PHYSICS_CATEGORY_WALLS);
			body.SetType(b2Body.b2_kinematicBody);
			
			body.SetLinearDamping(0.5);
			body.SetActive(false);
		}
		
		public function SetPlayer(plr:PlayerCharacter):void {
			var newPos:b2Vec2 = plr.body.GetPosition();
			newPos.Subtract(new b2Vec2(0, 2));
			body.SetPosition(newPos);
		}
		
		public function Update(dt:Number):void {
			this.x = Math.round(body.GetPosition().x * Global.PHYSICS_SCALE);
			this.y = Math.round(body.GetPosition().y * Global.PHYSICS_SCALE);
			
			body.SetLinearVelocityXY(0, WorldManager.WorldScrollSpeed);
			
			animation.Update(dt);
			animation.x = -animation.width / 2;
			animation.y = -animation.height + 0.8 * Global.PHYSICS_SCALE;
			
			if (animation.IsStopped() && state == RISING) {
				waitTime -= dt;
				
				if (waitTime < 0) {
					state = HITING;
					animation.ChangePlayback(0.25, 5, 5, true);
					
					waitTime = BASE_HURT_TIME;
				}
			} else if (animation.IsStopped() && state == HITING) {
				state = HURTIN;
				WorldManager.WorldShake += SCREENSHAKE_AMT;
				
				var aabb:b2AABB = new b2AABB();
				aabb.lowerBound.Set(body.GetPosition().x - 1.5, body.GetPosition().y - 1.5);
				aabb.upperBound.Set(body.GetPosition().x + 1.5, body.GetPosition().y + 1.5);
				
				WorldManager.World.QueryAABB(HittingCallback, aabb);
			} else if (animation.IsStopped() && state == HURTIN) {
				waitTime -= dt;
				
				if (waitTime < 0) {
					WorldManager.WorldShake -= SCREENSHAKE_AMT;
					body.GetFixtureList().SetSensor(true);
					
					state = HIDING;
					animation.ChangePlayback(0.1, 10, 4, true);
				}
			}
		}
		
		public function HittingCallback(fixture:b2Fixture):Boolean {
			if (fixture.GetUserData() is PlayerCharacter) {
				if ((fixture.GetUserData() as PlayerCharacter).Hit(9)) {
					TrophyHelper.GotTrophyByName("High Five");
				}
			}
			
			return true;
		}
		
		public function Hit(damage:Number):Boolean {
			return false;
		}
		
		public function HitPlayer(player:PlayerCharacter):Number {
			return 0;
		}
		
		public function OutsideScene():Boolean {
			if (this.y - animation.height > animation.stage.stageHeight) {
				return true;
			}
			
			return false;
		}
		
		public function AddToScene(position:b2Vec2, layer0:Sprite, layer1:Sprite):void {
			layer0.addChild(this);
			
			animation.ChangePlayback(0.1, 0, 6, true);
			
			state = RISING;
			waitTime = BASE_WAIT_TIME;
			
			body.SetActive(true);
			body.GetFixtureList().SetSensor(false);
			
			Update(0);
		}
		
		public function RemoveFromScene(layer0:Sprite, layer1:Sprite):void {
			body.SetPosition(new b2Vec2(0, -200));
			layer0.removeChild(this);
			body.SetActive(false);
		}
		
		public function GetPixelLocation():Point {
			return new Point(this.x, this.y);
		}
		
	}

}