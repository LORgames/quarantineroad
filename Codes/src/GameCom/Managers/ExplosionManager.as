package GameCom.Managers 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GameCom.GameComponents.Decorations.BigExplosion;
	import GameCom.GameComponents.Decorations.IExplosion;
	import GameCom.Helpers.AudioStore;
	import LORgames.Engine.AudioController;
	/**
	 * ...
	 * @author Paul
	 */
	public class ExplosionManager {
		
		public static var I:ExplosionManager;
		
		private var playing_explosions:Vector.<IExplosion> = new Vector.<IExplosion>();
		private var waiting_explosions:Vector.<IExplosion> = new Vector.<IExplosion>();
		
		private var layer:Sprite;
		
		public function ExplosionManager(layer:Sprite):void {
			I = this;
			this.layer = layer;
		}
		
		public function RequestExplosionAt(p:Point):void {
			if (waiting_explosions.length == 0) {
				var new_explosion:IExplosion = new BigExplosion();
				layer.addChild(new_explosion as Sprite);
				
				waiting_explosions.push(new_explosion);
			}
			
			var explosion:IExplosion = waiting_explosions.pop();
			
			(explosion as Sprite).visible = true;
			
			(explosion as Sprite).x = p.x;
			(explosion as Sprite).y = p.y;
			explosion.Reset();
			
			playing_explosions.push(explosion);
			
			WorldManager.Explode(new b2Vec2(p.x / Global.PHYSICS_SCALE, p.y / Global.PHYSICS_SCALE), 2.5, 100);
			
			AudioController.PlaySound(AudioStore.Explode);
		}
		
		public function Update(dt:Number):void {
			var explosion:MovieClip;
			
			for (var i:int = 0; i < playing_explosions.length; i++) {
				playing_explosions[i].Update(dt);
				
				if (playing_explosions[i].IsFinished()) {
					var e:IExplosion = playing_explosions.splice(i, 1)[0];
					(e as Sprite).visible = false;
					waiting_explosions.push(e);
					i--;
				}
			}
		}
		
		
	}

}