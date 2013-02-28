package GameCom.GameComponents 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.Sprite;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import GameCom.GameComponents.Loot.LootDrop;
	import GameCom.GameComponents.Weapons.BasicGun;
	import GameCom.GameComponents.Weapons.IWeapon;
	import GameCom.GameComponents.Zombies.IZombie;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Helpers.BodyHelper;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.WorldManager;
	import GameCom.States.GameScreen;
	import LORgames.Engine.Keys;
	import LORgames.Engine.MessageBox;
	/**
	 * ...
	 * @author Paul
	 */
	public class PlayerCharacter extends Sprite implements IHit {
		private var body:b2Body;
		private var animation:AnimatedSprite = new AnimatedSprite();
		
		private var MOVEMENT_SPEED:Number = 3.6;
		
		private var weapons:Vector.<IWeapon> = new Vector.<IWeapon>();
		
		private var myHP:int = 10;
		
		private var time:int = -1;
		private var startTime:int = 0;
		
		public function PlayerCharacter() {
			animation.AddFrame(ThemeManager.Get("Player/0_0.png"));
			animation.ChangePlayback(0.5, 0, 1);
			
			this.addChild(animation);
			
			body = BodyHelper.GetGenericCircle(0.6, Global.PHYSICS_CATEGORY_PLAYER, this);
			body.SetFixedRotation(true);
			body.SetLinearDamping(0.5);
			
			weapons.push(new BasicGun());
			weapons[0].AddSafe(body);
			
			startTime = getTimer();
		}
		
		public function Update(dt:Number):void {
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
			
			WorldManager.WorldTargetX = this.x;
			WorldManager.WorldTargetY = this.y;
			
			WorldManager.WorldScrollSpeed = ((stage.stageHeight - this.y) / stage.stageHeight) * 4 + 1;
			
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
			
			var contact:b2ContactEdge = body.GetContactList();
			
			while (contact != null) {
				
				if(contact.contact.IsTouching()) {
					if (contact.other.GetUserData() is LootDrop) {
						(contact.other.GetUserData() as LootDrop).Pickup(weapons);
					} else if (contact.other.GetUserData() is IZombie) {
						Hit(1);
						(contact.other.GetUserData() as IZombie).Hit(int.MAX_VALUE);
					}
				}
				
				contact = contact.next;
			}
		}
		
		public function Hit(damage:Number):void {
			myHP -= damage;
			GUIManager.I.Hearts.SetHealth(myHP);
			
			if (myHP <= 0 && time == -1) {
				new MessageBox("You died after " + ((getTimer() - startTime)/1000 as Number).toFixed(2) + "s", 0);
				time = 1;
				GameScreen.EndOfTheLine_TerminateASAP = true;
			}
		}
		
	}

}