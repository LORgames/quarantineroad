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
	public class ThrowUpZombie extends Sprite implements IZombie {
		private const BASE_HP:Number = 1.0;
		private const BASE_SPEED:Number = 0.5;
		private const SCORE:int = 1;
		private const RADIUS:Number = 0.9;
		
		private const WALKING:int = 0;
		private const THROWING_UP:int = 1;
		
		
		private var body:b2Body;
		
		private var myHP:Number = 1;
		private var mySpeed:Number = 0.5;
		private var dead:Boolean = false;
		
		private var animation:AnimatedSprite = new AnimatedSprite();
		
		private var stopped:Boolean = true;
		private var throwupTime:Number = 0;
		private var myState:int = WALKING;
		
		public function ThrowUpZombie() {
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/0_0.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/0_1.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/0_2.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/0_3.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/0_4.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/0_5.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/0_6.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/0_7.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/0_8.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/0_9.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/0_10.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/0_11.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/0_12.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/0_13.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/0_14.png"));
			animation.ChangePlayback(0.1, 0, 1);
			this.addChild(animation);
			
			//Create the defintion
			body = BodyHelper.GetGenericCircle(RADIUS, Global.PHYSICS_CATEGORY_ZOMBIES, this, 0xFFFF & ~Global.PHYSICS_CATEGORY_WALLS & ~Global.PHYSICS_CATEGORY_VOMIT);
		}
		
		public function Update(dt:Number):void {
			this.x = Math.round(body.GetPosition().x * Global.PHYSICS_SCALE);
			this.y = Math.round(body.GetPosition().y * Global.PHYSICS_SCALE);
			
			animation.Update(dt);
			animation.x = -animation.width / 2;
			animation.y = -animation.height + RADIUS * Global.PHYSICS_SCALE;
			
			throwupTime -= dt;
			
			if (throwupTime <= 0 && myState != THROWING_UP) {
				stopped = true;
				animation.ChangePlayback(0.1, 0, 15, true);
				myState = THROWING_UP;
			} else if (myState == THROWING_UP) {
				if (animation.IsStopped()) {
					stopped = false;
					
					ExplosionManager.I.RequestVomitAt(new Point(this.x, this.y));
					
					throwupTime = Math.random() * 3 + 2;
					myState = WALKING;
					animation.ChangePlayback(0.1, 0, 1);
				}
			}
			
			var xSpeed:Number = 0;
			var ySpeed:Number = (stopped?0:mySpeed) + WorldManager.WorldScrollSpeed;
			
			//TODO: Logic to set X and Y speeds
			if (this.y < WorldManager.WorldTargetY+100 && WorldManager.WorldTargetY - this.y < stage.stageHeight / 3) {
				if (this.x < WorldManager.WorldTargetX) {
					xSpeed = (stopped?0:2);
				} else {
					xSpeed = (stopped?0:-2);
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
				
				BGManager.I.AddBloodSplatter(this.x, this.y);
			}
		}
		
		public function HitPlayer(player:PlayerCharacter):Number {
			Hit(myHP);
			return 1;
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
			dead = false;
			
			throwupTime = Math.random() * 30;
			
			mySpeed = Math.random() + 0.5 + BASE_SPEED;
			
			Update(0);
		}
		
		public function RemoveFromScene(layer0:Sprite, layer1:Sprite):void {
			layer0.removeChild(this);
			
			body.SetActive(false);
		}
		
	}

}