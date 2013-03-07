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
	public class SniperTrail extends Sprite implements IExplosion {
		private static const TIMEOUT:Number = 0.7;
		private var timeout:Number;
		
		public function SniperTrail() {
			
		}
		
		public function Reset():void {
			timeout = TIMEOUT;
			
			this.x = int(this.x);
			this.y = int(this.y);
		}
		
		public function Deactivate():void {
			this.graphics.clear();
		}
		
		public function IsFinished():Boolean {
			return timeout <= 0;
		}
		
		public function Update(dt:Number):void {
			timeout -= dt;
			
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF, timeout / TIMEOUT);
			this.graphics.drawRect(-1, 0, 1, 40);
			this.graphics.endFill();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////// VOMIT CONTROLLER
		////////////////////////////////////////////////////////////////////////////////////////////////
		private static var playing_effects:Vector.<SniperTrail> = new Vector.<SniperTrail>();
		private static var waiting_effects:Vector.<SniperTrail> = new Vector.<SniperTrail>();
		private static var layer:Sprite;
		
		public static function SetLayer(_layer:Sprite):void {
			if (layer != null) {
				while(playing_effects.length > 0) {
					var b:SniperTrail = playing_effects.pop();
					layer.removeChild(b);
					waiting_effects.push(b);
				}
			}
			
			layer = _layer;
		}
		
		public static function RequestAt(x:Number, y:Number):void {
			if (waiting_effects.length == 0) {
				var new_effect:SniperTrail = new SniperTrail();
				waiting_effects.push(new_effect);
			}
			
			var effect:SniperTrail = waiting_effects.pop();
			
			layer.addChild(effect);
			
			effect.x = x;
			effect.y = y;
			effect.Reset();
			
			playing_effects.push(effect);
		}
		
		public static function Update(dt:Number):void {
			for (var i:int = 0; i < playing_effects.length; i++) {
				playing_effects[i].Update(dt);
				
				if (playing_effects[i].IsFinished()) {
					var b:SniperTrail = playing_effects.splice(i, 1)[0];
					layer.removeChild(b);
					b.Deactivate();
					waiting_effects.push(b);
					i--;
				}
			}
		}
	}

}