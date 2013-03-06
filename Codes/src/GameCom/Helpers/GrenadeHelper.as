package GameCom.Helpers {
	import flash.display.Sprite;
	import GameCom.GameComponents.Decorations.Grenade;
	/**
	 * ...
	 * @author Paul
	 */
	public class GrenadeHelper {
		public static var I:GrenadeHelper;
		
		private var Used_Grenades:Vector.<Grenade> = new Vector.<Grenade>();
		private var Spare_Grenades:Vector.<Grenade> = new Vector.<Grenade>();
		
		private var Layer:Sprite;
		
		public function GrenadeHelper(layer:Sprite) {
			I = this;
			
			this.Layer = layer;
		}
		
		public function SpawnGrenade(xPos:Number, yPos:Number):void {
			if (Spare_Grenades.length == 0) {
				Spare_Grenades.push(new Grenade());
			}
			
			var grenade:Grenade = Spare_Grenades.pop();
			
			grenade.x = xPos;
			grenade.y = yPos;
			
			grenade.Reset();
			Layer.addChild(grenade);
			
			Used_Grenades.push(grenade);
		}
		
		public function Update(dt:Number):void {
			for (var i:int = 0; i < Used_Grenades.length; i++) {
				Used_Grenades[i].Update(dt);
				
				if (Used_Grenades[i].IsFinished()) {
					Used_Grenades[i].Deactivate();
					
					Spare_Grenades.push(Used_Grenades.splice(i, 1)[0]);
				}
			}
		}
		
	}

}