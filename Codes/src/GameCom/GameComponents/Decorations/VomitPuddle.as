package GameCom.GameComponents.Decorations 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import GameCom.GameComponents.PlayerCharacter;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Helpers.BodyHelper;
	import GameCom.Managers.WorldManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class VomitPuddle extends Sprite implements IExplosion {
		private var animation:AnimatedSprite;
		private var body:b2Body;
		private var body2:b2Body;
		
		public function VomitPuddle() {
			animation = new AnimatedSprite();
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/0.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/1.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/2.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/3.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/4.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/5.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/6.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/7.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/8.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/9.png"));
			
			animation.Update(0);
			this.addChild(animation);
			
			animation.x = -animation.width / 2;
			animation.y = -animation.height / 2;
			
			body = BodyHelper.GetGenericCircle(1.5, Global.PHYSICS_CATEGORY_VOMIT, this, 0xFFFF & ~Global.PHYSICS_CATEGORY_BULLETS & ~Global.PHYSICS_CATEGORY_PLAYER);
			body.SetType(b2Body.b2_kinematicBody);
			
			body2 = BodyHelper.GetGenericCircle(1.5, Global.PHYSICS_CATEGORY_VOMIT, this, 0xFFFF);
			body2.GetFixtureList().SetSensor(true);
			body2.SetType(b2Body.b2_kinematicBody);
		}
		
		public function Reset():void {
			body.SetPosition(new b2Vec2(this.x / Global.PHYSICS_SCALE, this.y / Global.PHYSICS_SCALE));
			body.SetActive(true);
			body2.SetPosition(new b2Vec2(this.x / Global.PHYSICS_SCALE, this.y / Global.PHYSICS_SCALE));
			body2.SetActive(true);
			animation.ChangePlayback(0.1, 0, 10);
		}
		
		public function Deactivate():void {
			body.SetActive(false);
			body2.SetActive(false);
		}
		
		public function IsFinished():Boolean {
			return animation.IsStopped();
		}
		
		public function Update(dt:Number):void {
			animation.Update(dt);
			
			body.SetLinearVelocity(new b2Vec2(0, WorldManager.WorldScrollSpeed));
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
			
			body2.SetLinearVelocity(new b2Vec2(0, WorldManager.WorldScrollSpeed));
			
			var edge:b2ContactEdge = body2.GetContactList();
			while (edge != null) {
				if (edge.contact.IsTouching()) {
					if (edge.other.GetUserData() is PlayerCharacter) {
						(edge.other.GetUserData() as PlayerCharacter).Hit(1);
					}
				}
				
				edge = edge.next;
			}
		}
	}

}