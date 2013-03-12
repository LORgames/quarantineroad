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
		
		public function VomitPuddle() {
			animation = new AnimatedSprite();
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/1.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/2.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/3.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/4.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/5.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/6.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/7.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/8.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/9.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/10.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/11.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/12.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/13.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/14.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/15.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Poison/Acid/16.png"));
			
			animation.ChangePlayback(0.1, 0, 5, true);
			animation.Update(0);
			
			this.addChild(animation);
			
			animation.x = -animation.width / 2;
			animation.y = -animation.height * 0.7;
			
			body = BodyHelper.GetGenericCircle(1.5, Global.PHYSICS_CATEGORY_VOMIT, this, 0xFFFF);
			body.GetFixtureList().SetSensor(true);
			body.SetType(b2Body.b2_kinematicBody);
		}
		
		public function Reset():void {
			body.SetPosition(new b2Vec2(this.x / Global.PHYSICS_SCALE, this.y / Global.PHYSICS_SCALE));
			body.SetActive(true);
			
			animation.ChangePlayback(0.1, 0, 5, true);
			animation.Update(0);
		}
		
		public function Deactivate():void {
			body.SetActive(false);
		}
		
		public function IsFinished():Boolean {
			return this.y-50 > stage.stageHeight;
		}
		
		public function Update(dt:Number):void {
			if (animation.IsStopped()) animation.ChangePlayback(0.1, 5, 11);
			animation.Update(dt);
			
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
			
			body.SetLinearVelocity(new b2Vec2(0, WorldManager.WorldScrollSpeed));
			
			var edge:b2ContactEdge = body.GetContactList();
			while (edge != null) {
				if (edge.contact.IsTouching()) {
					if (edge.other.GetUserData() is PlayerCharacter) {
						(edge.other.GetUserData() as PlayerCharacter).Hit(1);
					}
				}
				
				edge = edge.next;
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////// VOMIT CONTROLLER
		////////////////////////////////////////////////////////////////////////////////////////////////
		private static var playing_explosions:Vector.<VomitPuddle> = new Vector.<VomitPuddle>();
		private static var waiting_explosions:Vector.<VomitPuddle> = new Vector.<VomitPuddle>();
		private static var layer:Sprite;
		
		public static function SetLayer(_layer:Sprite):void {
			if (layer != null) {
				while(playing_explosions.length > 0) {
					var b:VomitPuddle = playing_explosions.pop();
					layer.removeChild(b);
					waiting_explosions.push(b);
				}
			}
			
			layer = _layer;
		}
		
		public static function RequestAt(x:Number, y:Number):void {
			if (waiting_explosions.length == 0) {
				var new_explosion:VomitPuddle = new VomitPuddle();
				waiting_explosions.push(new_explosion);
			}
			
			var explosion:VomitPuddle = waiting_explosions.pop();
			
			layer.addChild(explosion);
			
			explosion.x = x;
			explosion.y = y;
			explosion.Reset();
			
			playing_explosions.push(explosion);
		}
		
		public static function Update(dt:Number):void {
			for (var i:int = 0; i < playing_explosions.length; i++) {
				playing_explosions[i].Update(dt);
				
				if (playing_explosions[i].IsFinished()) {
					var b:VomitPuddle = playing_explosions.splice(i, 1)[0];
					layer.removeChild(b);
					b.Deactivate();
					waiting_explosions.push(b);
					i--;
				}
			}
		}
	}

}