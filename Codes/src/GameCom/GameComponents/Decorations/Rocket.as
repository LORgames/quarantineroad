package GameCom.GameComponents.Decorations {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import GameCom.GameComponents.Weapons.IWeapon;
	import GameCom.GameComponents.Zombies.IZombie;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Helpers.BodyHelper;
	import GameCom.Managers.ExplosionManager;
	import GameCom.Managers.WorldManager;
	/**
	 * ...
	 * @author ...
	 */
	public class Rocket extends Sprite {
		private var animation:AnimatedSprite;
		private var body:b2Body;
		
		private var owner:IWeapon;
		private var isDead:Boolean = false;
		
		public function Rocket() {
			animation = new AnimatedSprite();
			animation.AddFrame(ThemeManager.Get("bullets/Rocket_0.png"));
			animation.AddFrame(ThemeManager.Get("bullets/Rocket_1.png"));
			animation.AddFrame(ThemeManager.Get("bullets/Rocket_2.png"));
			
			animation.ChangePlayback(0.1, 0, 1, true);
			animation.Update(0.5);
			this.addChild(animation);
			
			animation.x = -animation.width / 2;
			animation.y = -animation.height + 0.4 * Global.PHYSICS_SCALE;
			
			body = BodyHelper.GetGenericCircle(0.4, Global.PHYSICS_CATEGORY_BULLETS, this, 0xFFFF & ~Global.PHYSICS_CATEGORY_PLAYER);
			body.SetType(b2Body.b2_dynamicBody);
			body.GetFixtureList().SetRestitution(0.3);
			body.SetActive(false);
			body.SetBullet(true);
		}
		
		public function Reset(owner:IWeapon):void {
			body.SetPosition(new b2Vec2(this.x / Global.PHYSICS_SCALE, this.y / Global.PHYSICS_SCALE));
			body.SetActive(true);
			
			animation.ChangePlayback(0.1, 0, 2);
			
			body.SetLinearVelocityXY(0, -15 + WorldManager.WorldScrollSpeed);
			isDead = false;
			
			this.owner = owner;
		}
		
		public function Deactivate():void {
			body.SetActive(false);
			body.SetPositionXY(483, 483);
			
			if (this.parent != null) {
				this.parent.removeChild(this);
			}
		}
		
		public function IsFinished():Boolean {
			if (body.GetPosition().y < 0) return true;
			return isDead;
		}
		
		public function Update(dt:Number):void {
			animation.Update(dt);
			
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
			
			var edge:b2ContactEdge = body.GetContactList();
			while (edge != null) {
				if (edge.contact.IsTouching() && edge.other.GetUserData() is IZombie) {
					owner.ReportKills(ExplosionManager.I.RequestBombExplosionAt(new Point(this.x, this.y)));
					isDead = true;
				}
				
				edge = edge.next;
			}
		}
		
	}

}