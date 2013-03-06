package GameCom.GameComponents.Decorations {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Helpers.BodyHelper;
	import GameCom.Managers.ExplosionManager;
	import GameCom.Managers.WorldManager;
	/**
	 * ...
	 * @author ...
	 */
	public class Grenade extends Sprite {
		private var animation:AnimatedSprite;
		private var body:b2Body;
		
		public function Grenade() {
			animation = new AnimatedSprite();
			animation.AddFrame(ThemeManager.Get("Grenade/Grenade0_0.png"));
			animation.AddFrame(ThemeManager.Get("Grenade/Grenade0_1.png"));
			animation.AddFrame(ThemeManager.Get("Grenade/Grenade0_2.png"));
			animation.AddFrame(ThemeManager.Get("Grenade/Grenade0_3.png"));
			animation.AddFrame(ThemeManager.Get("Grenade/Grenade0_4.png"));
			animation.AddFrame(ThemeManager.Get("Grenade/Grenade0_5.png"));
			animation.AddFrame(ThemeManager.Get("Grenade/Grenade0_6.png"));
			animation.AddFrame(ThemeManager.Get("Grenade/Grenade0_7.png"));
			animation.AddFrame(ThemeManager.Get("Grenade/Grenade0_8.png"));
			animation.AddFrame(ThemeManager.Get("Grenade/Grenade0_9.png"));
			animation.AddFrame(ThemeManager.Get("Grenade/Grenade0_10.png"));
			animation.AddFrame(ThemeManager.Get("Grenade/Grenade0_11.png"));
			animation.AddFrame(ThemeManager.Get("Grenade/Grenade0_12.png"));
			
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
		
		public function Reset():void {
			body.SetPosition(new b2Vec2(this.x / Global.PHYSICS_SCALE, this.y / Global.PHYSICS_SCALE));
			body.SetActive(true);
			
			animation.ChangePlayback(0.1, 0, 13, true);
			
			body.SetLinearVelocity(new b2Vec2(0,0));
			body.SetAngularVelocity(0);
			
			var throwSpeed:b2Vec2 = new b2Vec2(0, -0.5);
			body.ApplyImpulse(throwSpeed, body.GetWorldCenter());
		}
		
		public function Deactivate():void {
			body.SetActive(false);
			
			if (this.parent != null) {
				this.parent.removeChild(this);
			}
		}
		
		public function IsFinished():Boolean {
			return animation.IsStopped();
		}
		
		public function Update(dt:Number):void {
			animation.Update(dt);
			
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
			
			if (animation.IsStopped()) {
				ExplosionManager.I.RequestCarExplosionAt(new Point(this.x, this.y));
				this.parent.removeChild(this);
				Deactivate();
			}
		}
		
	}

}