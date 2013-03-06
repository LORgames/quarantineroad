package GameCom.Managers 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	import GameCom.GameComponents.Scenary.ExplosiveCar;
	/**
	 * ...
	 * @author Paul
	 */
	public class ScenicManager {
		
		private var cars:Vector.<ExplosiveCar> = new Vector.<ExplosiveCar>();
		private var activecars:Vector.<ExplosiveCar> = new Vector.<ExplosiveCar>();
		
		private var spawnTimeout:Number = 3;
		
		private const SPAWNTIME_MIN:Number = 10;
		private const SPAWNTIME_RANGE:Number = 10; // MIN to MIN+RANGE seconds [10->20s]
		
		private var layer:Sprite;
		
		public function ScenicManager(layer:Sprite) {
			cars.push(new ExplosiveCar(0));
			cars.push(new ExplosiveCar(1));
			cars.push(new ExplosiveCar(2));
			cars.push(new ExplosiveCar(3));
			
			this.layer = layer;
		}
		
		public function Update(dt:Number):void {
			spawnTimeout -= dt;
			if (spawnTimeout <= 0) {
				var car:ExplosiveCar = cars.splice(Math.random() * cars.length, 1)[0];
				
				car.AddToScene(new b2Vec2((Math.random() - 0.5) * Global.SCREEN_WIDTH / Global.PHYSICS_SCALE * 0.5, -1), null, null);
				activecars.push(car);
				layer.addChild(car);
				
				spawnTimeout = SPAWNTIME_MIN + Math.random() * SPAWNTIME_RANGE;
			}
			
			for (var i:int = 0; i < activecars.length; i++) {
				activecars[i].Update(dt);
				
				if (activecars[i].OutsideScene()) {
					activecars[i].RemoveFromScene(null, null);
					layer.removeChild(activecars[i]);
					cars.push(activecars.splice(i, 1)[0]);
					i--;
				}
			}
		}
		
	}

}