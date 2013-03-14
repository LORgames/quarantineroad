package GameCom.Managers 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.geom.Point;
	import GameCom.GameComponents.Decorations.CarExplosion;
	import GameCom.GameComponents.Decorations.BloodExplosion;
	import GameCom.GameComponents.Decorations.GrenadeExplosion;
	import GameCom.GameComponents.Decorations.IExplosion;
	import GameCom.GameComponents.Decorations.SniperTrail;
	import GameCom.GameComponents.Decorations.SqlshExplosion;
	import GameCom.GameComponents.Decorations.VomitPuddle;
	import GameCom.Helpers.AudioStore;
	import LORgames.Engine.AudioController;
	/**
	 * ...
	 * @author Paul
	 */
	public class ExplosionManager {
		
		public static var I:ExplosionManager;
		
		private var playing_car_explosions:Vector.<CarExplosion> = new Vector.<CarExplosion>();
		private var waiting_car_explosions:Vector.<CarExplosion> = new Vector.<CarExplosion>();
		
		private var playing_blood_effects:Vector.<BloodExplosion> = new Vector.<BloodExplosion>();
		private var waiting_blood_effects:Vector.<BloodExplosion> = new Vector.<BloodExplosion>();
		
		private var playing_puddle_effects:Vector.<VomitPuddle> = new Vector.<VomitPuddle>();
		private var waiting_puddle_effects:Vector.<VomitPuddle> = new Vector.<VomitPuddle>();
		
		private var playing_bomb_explosions:Vector.<GrenadeExplosion> = new Vector.<GrenadeExplosion>();
		private var waiting_bomb_explosions:Vector.<GrenadeExplosion> = new Vector.<GrenadeExplosion>();
		
		private var layer:Sprite;
		private var layer1:Sprite;
		
		public function ExplosionManager(layer:Sprite, layer1:Sprite):void {
			I = this;
			this.layer = layer;
			this.layer1 = layer1;
			
			SqlshExplosion.SetLayer(layer);
			VomitPuddle.SetLayer(layer1);
			SniperTrail.SetLayer(layer);
		}
		
		public function RequestCarExplosionAt(p:Point, damage:Number = 100):void {
			if (waiting_car_explosions.length == 0) {
				var new_explosion:CarExplosion = new CarExplosion();
				layer.addChild(new_explosion);
				
				waiting_car_explosions.push(new_explosion);
			}
			
			var explosion:CarExplosion = waiting_car_explosions.pop();
			
			explosion.visible = true;
			
			explosion.x = p.x;
			explosion.y = p.y;
			explosion.Reset();
			
			playing_car_explosions.push(explosion);
			
			WorldManager.Explode(new b2Vec2(p.x / Global.PHYSICS_SCALE, p.y / Global.PHYSICS_SCALE), 2.5, damage);
			
			AudioController.PlaySound(AudioStore.Explode);
		}
		
		public function RequestBombExplosionAt(p:Point, damage:Number = 1500):int {
			if (waiting_bomb_explosions.length == 0) {
				var new_explosion:GrenadeExplosion = new GrenadeExplosion();
				layer.addChild(new_explosion);
				
				waiting_bomb_explosions.push(new_explosion);
			}
			
			var explosion:GrenadeExplosion = waiting_bomb_explosions.pop();
			
			explosion.visible = true;
			
			explosion.x = p.x;
			explosion.y = p.y;
			explosion.Reset();
			
			playing_bomb_explosions.push(explosion);
			
			AudioController.PlaySound(AudioStore.Explode);
			
			return WorldManager.Explode(new b2Vec2(p.x / Global.PHYSICS_SCALE, p.y / Global.PHYSICS_SCALE), 1.5, damage);
		}
		
		public function RequestBloodAt(x:Number, y:Number):void {
			if (waiting_blood_effects.length == 0) {
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
			
			for (i = 0; i < playing_car_explosions.length; i++) {
				playing_car_explosions[i].Update(dt);
				
				if (playing_car_explosions[i].IsFinished()) {
					var e:CarExplosion = playing_car_explosions.splice(i, 1)[0];
					e.visible = false;
					waiting_car_explosions.push(e);
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
			
			for (i = 0; i < playing_bomb_explosions.length; i++) {
				playing_bomb_explosions[i].Update(dt);
				
				if (playing_bomb_explosions[i].IsFinished()) {
					var g:GrenadeExplosion = playing_bomb_explosions.splice(i, 1)[0];
					g.visible = false;
					waiting_bomb_explosions.push(g);
					i--;
				}
			}
			
			SqlshExplosion.Update(dt);
			VomitPuddle.Update(dt);
			SniperTrail.Update(dt);
		}
		
		
	}

}