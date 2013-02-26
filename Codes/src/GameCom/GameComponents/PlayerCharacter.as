package GameCom.GameComponents 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	import flash.ui.Keyboard;
	import GameCom.GameComponents.Weapons.BasicGun;
	import GameCom.GameComponents.Weapons.IWeapon;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Helpers.BodyHelper;
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
		
		private var weapons:Vector.<IWeapon> = new Vector.<IWeapon>();
		
		public function PlayerCharacter() {
			animation.AddFrame(ThemeManager.Get("Player/0_0.png"));
			animation.ChangePlayback(0.5, 0, 1);
			
			this.addChild(animation);
			
			body = BodyHelper.GetGenericCircle(0.6, Global.PHYSCAT_PLAYER, this);
			body.SetFixedRotation(true);
			body.SetLinearDamping(0.5);
			
			weapons.push(new BasicGun());
			weapons[0].AddSafe(body);
		}
		
		public function Update(dt:Number):void {
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
			
			animation.Update(dt);
			
			animation.x = -animation.width / 2;
			animation.y = -animation.height + 0.6 * Global.PHYSICS_SCALE;
			
			for (var i:int = 0; i < weapons.length; i++) {
				weapons[i].Update(dt, new b2Vec2(0.3 + body.GetPosition().x, -1 + body.GetPosition().y));
			}
			
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
		}
		
	}

}