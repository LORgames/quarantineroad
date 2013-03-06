package GameCom.GameComponents.Zombies {
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
		private const BASE_WAIT_TIME:Number = 0.0;
		private const SCREENSHAKE_AMT:Number = 50.0;
		
		private const RISING:int = 0;
		private const HITING:int = 1;
		private const HIDING:int = 2;
		
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
		}
		
		public function SetPlayer(plr:PlayerCharacter):void {
			var newPos:b2Vec2 = plr.body.GetPosition();
			newPos.Subtract(new b2Vec2(0, 2));
			body.SetPosition(newPos);
		}
		
		public function Update(dt:Number):void {
			this.x = Math.round(body.GetPosition().x * Global.PHYSICS_SCALE);
			this.y = Math.round(body.GetPosition().y * Global.PHYSICS_SCALE);
			
			body.SetLinearVelocity(new b2Vec2(0, WorldManager.WorldScrollSpeed));
			
			animation.Update(dt);
			animation.x = -animation.width / 2;
			animation.y = -animation.height + 0.6 * Global.PHYSICS_SCALE;
			
			if (animation.IsStopped() && state == RISING) {
				waitTime -= dt;
				
				if (waitTime < 0) {
					state = HITING;
					animation.ChangePlayback(0.25, 9, 1, true);
					
					WorldManager.WorldShake += SCREENSHAKE_AMT;
				}
			} else if (animation.IsStopped() && state == HITING) {
				WorldManager.WorldShake -= SCREENSHAKE_AMT;
				
				state = HIDING;
				animation.ChangePlayback(0.1, 10, 4, true);
			}
		}
		
		public function Hit(damage:Number):void {
			
		}
		
		public function HitPlayer(player:PlayerCharacter):Number {
			return 1;
		}
		
		public function OutsideScene():Boolean {
			if (this.y - animation.height > animation.stage.stageHeight) {
				return true;
			}
			
			return false;
		}
		
		public function AddToScene(position:b2Vec2, layer0:Sprite, layer1:Sprite):void {
			layer0.addChild(this);
			
			body.SetActive(true);
			//body.SetPosition(position);
			
			animation.ChangePlayback(0.1, 0, 10, true);
			
			state = RISING;
			waitTime = BASE_WAIT_TIME;
			
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