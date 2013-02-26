package GameCom.GameComponents.Projectiles {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.Sprite;
	import GameCom.GameComponents.IHit;
	import GameCom.GameComponents.Weapons.IWeapon;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Helpers.BodyHelper;
	/**
	 * ...
	 * @author Paul
	 */
	public class BasicBullet extends Sprite implements IBullet {
		
		public const DAMAGE:Number = 5;
		private var owner:IWeapon;
		
		private var animation:AnimatedSprite = new AnimatedSprite();
		
		private var body:b2Body;
		
		private var hitSomething:Boolean = false;
		
		public function BasicBullet() {
			animation.AddFrame(ThemeManager.Get("bullets/bullet0_0.png"));
			animation.AddFrame(ThemeManager.Get("bullets/bullet0_1.png"));
			animation.ChangePlayback(0.1, 0, 2);
			this.addChild(animation);
			
			body = BodyHelper.GetGenericCircle(0.1, Global.PHYSCAT_PLAYER, this, 0xFFFF & ~Global.PHYSCAT_WALLS);
			body.SetActive(false);
			body.SetBullet(true);
		}
		
		public function Update(dt:Number):void {
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
			
			animation.Update(dt);
			animation.x = -animation.width / 2;
			animation.y = -animation.height + 0.1 * Global.PHYSICS_SCALE;
			
			body.SetLinearVelocity(new b2Vec2(0, -15));
			
			var contact:b2ContactEdge = body.GetContactList();
			while (contact != null) {
				if (contact.contact.IsTouching() && contact.other.GetUserData() is IHit && !owner.IsSafe(contact.other)) {
					(contact.other.GetUserData() as IHit).Hit(DAMAGE);
					hitSomething = true;
				}
				
				contact = contact.next;
			}
		}
		
		public function GetDamage():Number {
			return DAMAGE;
		}
		
		public function GetOwner():IWeapon {
			return owner;
		}
		
		public function ShouldRemove():Boolean {
			if (hitSomething) return true;
			return (body.GetPosition().y < 0);
		}
		
		public function SetLocationAndActivate(newLocation:b2Vec2, newOwner:IWeapon, layer:Sprite):void {
			this.owner = newOwner;
			
			body.SetPosition(newLocation);
			body.SetActive(true);
			
			layer.addChild(this);
			
			hitSomething = false;
		}
		
		public function Deactivate(layer:Sprite):void {
			body.SetActive(false);
			layer.removeChild(this);
		}
	}

}