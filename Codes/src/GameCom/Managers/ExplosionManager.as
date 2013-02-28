package GameCom.Managers 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GameCom.GameComponents.Decorations.BigExplosion;
	import GameCom.GameComponents.Decorations.BloodExplosion;
	import GameCom.GameComponents.Decorations.IExplosion;
	import GameCom.Helpers.AudioStore;
	import LORgames.Engine.AudioController;
	/**
	 * ...
	 * @author Paul
	 */
	public class ExplosionManager {
		
		public static var I:ExplosionManager;
		
		private var playing_explosions:Vector.<BigExplosion> = new Vector.<BigExplosion>();
		private var waiting_explosions:Vector.<BigExplosion> = new Vector.<BigExplosion>();
		
		private var playing_blood_effects:Vector.<BloodExplosion> = new Vector.<BloodExplosion>();
		private var waiting_blood_effects:Vector.<BloodExplosion> = new Vector.<BloodExplosion>();
		
		private var layer:Sprite;
		
		public function ExplosionManager(layer:Sprite):void {
			I = this;
			this.layer = layer;
		}
		
		public function RequestExplosionAt(p:Point):void {
			if (waiting_explosions.length == 0) {
				var new_explosion:BigExplosion = new BigExplosion();
				layer.addChild(new_explosion);
				
				waiting_explosions.push(new_explosion);
			}
			
			var explosion:BigExplosion = waiting_explosions.pop();
			
			explosion.visible = true;
			
			explosion.x = p.x;
			explosion.y = p.y;
			explosion.Reset();
			
			playing_explosions.push(explosion);
			
			WorldManager.Explode(new b2Vec2(p.x / Global.PHYSICS_SCALE, p.y / Global.PHYSICS_SCALE), 2.5, 100);
			
			AudioController.PlaySound(AudioStore.Explode);
		}
		
		public function RequestBloodAt(x:Number, y:Number):void {
			if (waiting_explosions.length == 0) {
				var new_explosion:BloodExplosion = new BloodExplosion();
				layer.addChild(new_explosion);
				
				waiting_blood_effects.push(new_explosion);
			}
			
			var explosion:BloodExplosion = waiting_blood_effects.pop();
			
			explosion.visible = true;
			
			explosion.x = x;
			explosion.y = y;
			explosion.Reset();
			
			playing_blood_effects.push(explosion);
		}
		
		public function Update(dt:Number):void {
			var explosion:MovieClip;
			
			var i:int;
			
			for (i = 0; i < playing_explosions.length; i++) {
				playing_explosions[i].Update(dt);
				
				if (playing_explosions[i].IsFinished()) {
					var e:BigExplosion = playing_explosions.splice(i, 1)[0];
					e.visible = false;
					waiting_explosions.push(e);
					i--;
				}
			}
			
			for (i = 0; i < playing_blood_effects.length; i++) {
				playing_blood_effects[i].Update(dt);
				
				if (playing_blood_effects[i].IsFinished()) {
					var b:BloodExplosion = playing_blood_effects.splice(i, 1)[0];
					b.visible = false;
					waiting_blood_effects.push(b);
					i--;
				}
			}
		}
		
		
	}

}