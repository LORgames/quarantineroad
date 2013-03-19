package GameCom.Helpers {
	import flash.display.Sprite;
	import GameCom.GameComponents.Decorations.Grenade;
	import GameCom.GameComponents.Decorations.Rocket;
	import GameCom.GameComponents.Weapons.IWeapon;
	/**
	 * ...
	 * @author Paul
	 */
	public class GrenadeHelper {
		public static var I:GrenadeHelper;
		
		private var Used_Grenades:Vector.<Grenade> = new Vector.<Grenade>();
		private var Spare_Grenades:Vector.<Grenade> = new Vector.<Grenade>();
		
		private var Used_Rockets:Vector.<Rocket> = new Vector.<Rocket>();
		private var Spare_Rockets:Vector.<Rocket> = new Vector.<Rocket>();
		
		private var Layer:Sprite;
		
		public function GrenadeHelper(layer:Sprite) {
			I = this;
			
			this.Layer = layer;
		}
		
		public function SpawnGrenade(xPos:Number, yPos:Number, owner:IWeapon):void {
			if (Spare_Grenades.length == 0) {
				Spare_Grenades.push(new Grenade());
			}
			
			var grenade:Grenade = Spare_Grenades.pop();
			
			grenade.x = xPos;
			grenade.y = yPos;
			
			grenade.Reset(owner);
			Layer.addChild(grenade);
			
			Used_Grenades.push(grenade);
		}
		
		public function SpawnRocket(xPos:Number, yPos:Number, owner:IWeapon):void {
			if (Spare_Rockets.length == 0) {
				Spare_Rockets.push(new Rocket());
			}
			
			var rocket:Rocket = Spare_Rockets.pop();
			
			rocket.x = xPos;
			rocket.y = yPos;
			
			rocket.Reset(owner);
			Layer.addChild(rocket);
			
			Used_Rockets.push(rocket);
		}
		
		public function Update(dt:Number):void {
			var i:int = 0;
			
			for (i = 0; i < Used_Grenades.length; i++) {
				Used_Grenades[i].Update(dt);
				
				if (Used_Grenades[i].IsFinished()) {
					Used_Grenades[i].Deactivate();
					Spare_Grenades.push(Used_Grenades.splice(i, 1)[0]);
				}
			}
			
			for (i = 0; i < Used_Rockets.length; i++) {
				Used_Rockets[i].Update(dt);
				
				if (Used_Rockets[i].IsFinished()) {
					Used_Rockets[i].Deactivate();
					Spare_Rockets.push(Used_Rockets.splice(i, 1)[0]);
				}
			}
		}
		
	}

}