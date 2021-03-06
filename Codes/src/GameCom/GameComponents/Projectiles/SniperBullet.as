package GameCom.GameComponents.Projectiles {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.Sprite;
	import GameCom.GameComponents.Decorations.SniperTrail;
	import GameCom.GameComponents.IHit;
	import GameCom.GameComponents.Weapons.IWeapon;
	import GameCom.GameComponents.Weapons.Sniper;
	import GameCom.GameComponents.Zombies.ExplosionZombie;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Helpers.BodyHelper;
	import GameCom.Helpers.TrophyHelper;
	import GameCom.Managers.ExplosionManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class SniperBullet extends Sprite implements IBullet {
		public const BASE_DAMAGE:Number = 1;
		
		private var damage:Number = 20;
		private var owner:IWeapon;
		
		private var spawnY:Number = 0;
		
		private var animation:AnimatedSprite = new AnimatedSprite();
		
		private var body:b2Body;
		
		public function SniperBullet() {
			animation.AddFrame(ThemeManager.Get("bullets/SniperShot.png"));
			animation.ChangePlayback(0.1, 0, 1, true);
			this.addChild(animation);
			
			body = BodyHelper.GetGenericCircle(0.1, Global.PHYSICS_CATEGORY_BULLETS, this, 0xFFFF & ~Global.PHYSICS_CATEGORY_WALLS & ~Global.PHYSICS_CATEGORY_BULLETS);
			body.SetActive(false);
			body.SetBullet(true);
			//body.GetFixtureList().SetSensor(true);
			body.SetType(b2Body.b2_kinematicBody);
		}
		
		public function Update(dt:Number):void {
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
			
			SniperTrail.RequestAt(this.x, this.y);
			
			animation.Update(dt);
			animation.x = -animation.width / 2;
			animation.y = -animation.height + 0.1 * Global.PHYSICS_SCALE;
			
			//TODO: Fix world scrolling in speed.
			body.SetLinearVelocity(new b2Vec2(0, -120));
			
			var contact:b2ContactEdge = body.GetContactList();
			while (contact != null) {
				if (contact.contact.IsTouching() && contact.other.GetUserData() is IHit && !owner.IsSafe(contact.other)) {
					if ((contact.other.GetUserData() as IHit).Hit(damage)) {
						owner.ReportKills(1);
					}
					
					if (spawnY - contact.other.GetPosition().y > 20) {
						(owner as Sniper).LongRange();
					}
					
					ExplosionManager.I.RequestBloodAt(this.x, animation.y + this.y);
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
			return (body.GetPosition().y < 0);
		}
		
		public function SetLocationAndActivate(newLocation:b2Vec2, newOwner:IWeapon, layer:Sprite, angle:Number = 0, distance:Number = 0, damage:Number = 0):void {
			this.owner = newOwner;
			
			body.SetPosition(newLocation);
			body.SetActive(true);
			
			spawnY = newLocation.y;
			
			layer.addChild(this);
		}
		
		public function Deactivate(layer:Sprite):void {
			body.SetActive(false);
			layer.removeChild(this);
		}
	}

}