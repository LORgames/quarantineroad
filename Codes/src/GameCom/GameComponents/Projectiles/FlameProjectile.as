package GameCom.GameComponents.Projectiles {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.Sprite;
	import GameCom.GameComponents.IHit;
	import GameCom.GameComponents.Weapons.IWeapon;
	import GameCom.GameComponents.Zombies.ExplosionZombie;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Helpers.BodyHelper;
	import GameCom.Managers.ExplosionManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class FlameProjectile extends Sprite implements IBullet {
		public const BASE_DAMAGE:Number = 1;
		public const TIME_TO_LIVE:Number = 1.5;
		
		private var damage:Number = 0.1;
		private var owner:IWeapon;
		
		private var angle:Number = 0;
		private var liveTime:Number = 0;
		
		private var animation:AnimatedSprite = new AnimatedSprite();
		
		private var body:b2Body;
		
		public function FlameProjectile() {
			animation.AddFrame(ThemeManager.Get("bullets/bullet0_0.png"));
			animation.AddFrame(ThemeManager.Get("bullets/bullet0_1.png"));
			animation.ChangePlayback(0.1, 0, 2);
			this.addChild(animation);
			
			body = BodyHelper.GetGenericCircle(0.1, Global.PHYSICS_CATEGORY_BULLETS, this, 0xFFFF & ~Global.PHYSICS_CATEGORY_WALLS & ~Global.PHYSICS_CATEGORY_BULLETS);
			body.SetActive(false);
			body.SetBullet(true);
			body.GetFixtureList().SetSensor(true);
		}
		
		public function Update(dt:Number):void {
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
			
			animation.Update(dt);
			animation.x = -animation.width / 2;
			animation.y = -animation.height + 0.1 * Global.PHYSICS_SCALE;
			
			//TODO: Fix world scrolling in speed.
			body.SetLinearVelocity(new b2Vec2(Math.sin(angle) * 15, -15 * Math.cos(angle)));
			
			var contact:b2ContactEdge = body.GetContactList();
			while (contact != null) {
				if (contact.contact.IsTouching() && contact.other.GetUserData() is IHit && !owner.IsSafe(contact.other)) {
					(contact.other.GetUserData() as IHit).Hit(damage);
					hitSomething = true;
					ExplosionManager.I.RequestBloodAt(this.x, animation.y+this.y);
					break;
				}
				
				contact = contact.next;
			}
		}
		
		public function GetDamage():Number {
			return damage;
		}
		
		public function GetOwner():IWeapon {
			return owner;
		}
		
		public function ShouldRemove():Boolean {
			if (liveTime <= 0) return false;
			return true;
		}
		
		public function SetLocationAndActivate(newLocation:b2Vec2, newOwner:IWeapon, layer:Sprite, angle:Number = 0, distance:Number = 0, damage:Number = 0):void {
			this.owner = newOwner;
			
			body.SetPosition(newLocation);
			body.SetActive(true);
			
			liveTime = TIME_TO_LIVE;
			
			this.damage = damage==0?BASE_DAMAGE:damage;
			
			this.angle = angle;
			
			layer.addChild(this);
			
			hitSomething = false;
		}
		
		public function Deactivate(layer:Sprite):void {
			body.SetActive(false);
			layer.removeChild(this);
		}
	}

}