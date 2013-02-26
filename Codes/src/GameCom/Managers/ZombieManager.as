package GameCom.Managers {
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	import GameCom.GameComponents.Zombies.IZombie;
	import GameCom.GameComponents.Zombies.SlowZombie;
	/**
	 * ...
	 * @author Paul
	 */
	public class ZombieManager {
		private var UsedZombies:Vector.<IZombie> = new Vector.<IZombie>();
		private var UnusedZombies:Vector.<IZombie> = new Vector.<IZombie>();
		
		private const TOTAL_ZOMBIES_ONSCREEN:int = 10;
		
		private var layer0:Sprite;
		private var layer1:Sprite;
		
		public function ZombieManager(layer0:Sprite, layer1:Sprite) {
			this.layer0 = layer0;
			this.layer1 = layer1;
			
			UnusedZombies.push(new SlowZombie());
			UnusedZombies.push(new SlowZombie());
			UnusedZombies.push(new SlowZombie());
			UnusedZombies.push(new SlowZombie());
			UnusedZombies.push(new SlowZombie());
			UnusedZombies.push(new SlowZombie());
			UnusedZombies.push(new SlowZombie());
			UnusedZombies.push(new SlowZombie());
			UnusedZombies.push(new SlowZombie());
			UnusedZombies.push(new SlowZombie());
		}
		
		public function Update(dt:Number):void {
			if (UsedZombies.length < TOTAL_ZOMBIES_ONSCREEN && UnusedZombies.length > 0) {
				var zombie:IZombie = UnusedZombies.splice(Math.random() * UnusedZombies.length, 1)[0];
				
				zombie.AddToScene(new b2Vec2((Math.random() - 0.5) * Global.SCREEN_WIDTH / Global.PHYSICS_SCALE * 0.9, Math.random() * -20), layer0, layer1);
				
				UsedZombies.push(zombie);
			}
			
			for (var i:int = 0; i < UsedZombies.length; i++) {
				UsedZombies[i].Update(dt);
				
				if (UsedZombies[i].OutsideScene()) {
					UsedZombies[i].RemoveFromScene(layer0, layer1);
					
					UnusedZombies.push(UsedZombies.splice(i, 1)[0]);
					i--;
				}
			}
		}
		
	}

}