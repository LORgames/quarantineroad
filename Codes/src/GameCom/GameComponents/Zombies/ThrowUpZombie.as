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
	import GameCom.GameComponents.Decorations.VomitPuddle;
	import GameCom.GameComponents.PlayerCharacter;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Helpers.BodyHelper;
	import GameCom.Helpers.ScoreHelper;
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
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Walk_1.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Walk_2.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Walk_3.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Walk_4.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Walk_5.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Walk_6.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Walk_7.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Walk_8.png"));
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
			
			animation.ChangePlayback(0.1, 0, 8);
			animation.Update(0);
			
			this.addChild(animation);
			
			//Create the defintion
			body = BodyHelper.GetGenericCircle(RADIUS, Global.PHYSICS_CATEGORY_ZOMBIES, this, 0xFFFF & ~Global.PHYSICS_CATEGORY_WALLS & ~Global.PHYSICS_CATEGORY_VOMIT);
			body.SetType(b2Body.b2_dynamicBody);
			body.SetActive(false);
			body.SetPositionAndAngleXY(60, -30, 0);
		}
		
		public function Update(dt:Number):void {
			this.x = Math.round(body.GetPosition().x * Global.PHYSICS_SCALE);
			this.y = Math.round(body.GetPosition().y * Global.PHYSICS_SCALE);
			
			throwupTime -= dt;
			
			if (throwupTime <= 0 && myState != THROWING_UP) {
				stopped = true;
				animation.ChangePlayback(0.1, 8, 15, true);
				myState = THROWING_UP;
				
				VomitPuddle.RequestAt(this.x, this.y);
				
				body.SetLinearDamping(1);
			} else if (myState == THROWING_UP) {
				if (animation.IsStopped()) {
					stopped = false;
					
					throwupTime = Math.random() * 5 + 5;
					myState = WALKING;
					animation.ChangePlayback(0.1, 0, 8);
					
					body.SetLinearDamping(0.1);
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
			
			animation.Update(dt);
			animation.x = -animation.width / 2;
			animation.y = -animation.height + RADIUS * Global.PHYSICS_SCALE;
			
			if(dt > 0) body.SetLinearVelocityXY(xSpeed, ySpeed);
		}
		
		public function Hit(damage:Number):Boolean {
			myHP -= damage;
			
			if (myHP <= 0 && !dead) {
				dead = true;
				
				ScoreHelper.Score.AddValue(SCORE);
				ScoreHelper.ThrowUpKills.AddValue(1);
				
				if (ScoreHelper.ThrowUpKills.Value == 25) {
					TrophyHelper.GotTrophyByName("My name is Hurl");
				}
				
				if(Math.random() < 0.001) {
					LootManager.I.SpawnAmmoAt(body.GetPosition());
				}
				
				BGManager.I.AddBloodSplatter(this.x, this.y, false);
				
				return true;
			}
			
			return false;
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
			body.SetLinearDamping(0.1);
			
			myHP = BASE_HP;
			dead = false;
			
			throwupTime = Math.random() * 5 + 5;
			
			mySpeed = Math.random() * 0.5 + BASE_SPEED;
			
			stopped = false;
			myState = WALKING;
			
			animation.ChangePlayback(0.1, 0, 8);
			animation.Update(0);
			
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