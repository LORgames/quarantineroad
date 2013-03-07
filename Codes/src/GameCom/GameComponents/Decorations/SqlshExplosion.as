package GameCom.GameComponents.Decorations 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Managers.WorldManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class SqlshExplosion extends Sprite implements IExplosion {
		
		private var animation:AnimatedSprite;
		private var endTime:int = 0;
		
		public function SqlshExplosion() {
			animation = new AnimatedSprite();
			animation.AddFrame(ThemeManager.Get("Explosion/sqlsh01.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/sqlsh02.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/sqlsh03.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/sqlsh04.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/sqlsh05.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/sqlsh06.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/sqlsh07.png"));
			
			animation.Update(0);
			this.addChild(animation);
			
			animation.x = -67;
			animation.y = -87;
		}
		
		public function Reset():void {
			animation.ChangePlayback(0.08, 0, 7, true);
		}
		
		public function IsFinished():Boolean {
			return animation.IsStopped();
		}
		
		public function Update(dt:Number):void {
			animation.Update(dt);
			this.y += WorldManager.WorldScrollSpeed * Global.PHYSICS_SCALE * dt;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////// SQLSH CONTROLLER
		////////////////////////////////////////////////////////////////////////////////////////////////
		private static var playing_explosions:Vector.<SqlshExplosion> = new Vector.<SqlshExplosion>();
		private static var waiting_explosions:Vector.<SqlshExplosion> = new Vector.<SqlshExplosion>();
		private static var layer:Sprite;
		
		public static function SetLayer(layer:Sprite):void {
			SqlshExplosion.layer = layer;
		}
		
		public static function RequestExplosionAt(p:Point):void {
			if (waiting_explosions.length == 0) {
				var new_explosion:SqlshExplosion = new SqlshExplosion();
				waiting_explosions.push(new_explosion);
			}
			
			var explosion:SqlshExplosion = waiting_explosions.pop();
			
			layer.addChild(explosion);
			
			explosion.x = p.x;
			explosion.y = p.y;
			explosion.Reset();
			
			playing_explosions.push(explosion);
			
			WorldManager.Explode(new b2Vec2(p.x / Global.PHYSICS_SCALE, p.y / Global.PHYSICS_SCALE), 2.5, 100);
		}
		
		public static function Update(dt:Number):void {
			for (var i:int = 0; i < playing_explosions.length; i++) {
				playing_explosions[i].Update(dt);
				
				if (playing_explosions[i].IsFinished()) {
					var b:SqlshExplosion = playing_explosions.splice(i, 1)[0];
					layer.removeChild(b);
					waiting_explosions.push(b);
					i--;
				}
			}
		}
	}

}