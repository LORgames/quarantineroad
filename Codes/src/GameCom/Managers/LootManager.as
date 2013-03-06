package GameCom.Managers {
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	import GameCom.GameComponents.Loot.LootDrop;
	import GameCom.GameComponents.Weapons.BasicGun;
	import GameCom.GameComponents.Zombies.IZombie;
	import GameCom.GameComponents.Zombies.SlowZombie;
	/**
	 * ...
	 * @author Paul
	 */
	public class LootManager {
		public static var I:LootManager;
		
		private var UsedLoot:Vector.<LootDrop> = new Vector.<LootDrop>();
		private var UnusedLoot:Vector.<LootDrop> = new Vector.<LootDrop>();
		
		private var layer:Sprite;
		
		public function LootManager(layer:Sprite) {
			this.layer = layer;
			I = this;
		}
		
		public function SpawnLootAt(location:b2Vec2, cls:Class = null):void {
			var loot:LootDrop;
			if(UnusedLoot.length > 0) {
				loot = UnusedLoot.pop();
			} else {
				loot = new LootDrop();
			}
			
			loot.Reassign(location);
			layer.addChild(loot);
			
			UsedLoot.push(loot);
		}
		
		public function Update(dt:Number):void {
			if (Math.random() < 0.00001) { //Very low chance to spawn random loot
				SpawnLootAt(new b2Vec2((Math.random() - 0.5) * Global.SCREEN_WIDTH / Global.PHYSICS_SCALE * 0.9, Math.random() * -20));
			}
			
			for (var i:int = 0; i < UsedLoot.length; i++) {
				UsedLoot[i].Update(dt);
				
				if (UsedLoot[i].ShouldDeactivate()) {
					UsedLoot[i].Deactivate();
					layer.removeChild(UsedLoot[i]);
					
					UnusedLoot.push(UsedLoot.splice(i, 1)[0]);
					i--;
				}
			}
		}
		
	}

}