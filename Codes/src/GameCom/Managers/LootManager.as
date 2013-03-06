package GameCom.Managers {
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	import GameCom.GameComponents.Loot.AmmoLootDrop;
	import GameCom.GameComponents.Loot.LootDrop;
	import GameCom.GameComponents.Loot.WeaponUpgradeLootDrop;
	import GameCom.GameComponents.Weapons.BasicGun;
	import GameCom.GameComponents.Zombies.IZombie;
	import GameCom.GameComponents.Zombies.SlowZombie;
	/**
	 * ...
	 * @author Paul
	 */
	public class LootManager {
		public static var I:LootManager;
		
		private var UsedWeapons:Vector.<WeaponUpgradeLootDrop> = new Vector.<WeaponUpgradeLootDrop>();
		private var UnusedWeapons:Vector.<WeaponUpgradeLootDrop> = new Vector.<WeaponUpgradeLootDrop>();
		
		private var UsedAmmo:Vector.<AmmoLootDrop> = new Vector.<AmmoLootDrop>();
		private var UnusedAmmo:Vector.<AmmoLootDrop> = new Vector.<AmmoLootDrop>();
		
		private var layer:Sprite;
		
		public function LootManager(layer:Sprite) {
			this.layer = layer;
			I = this;
		}
		
		public function SpawnWeaponAt(location:b2Vec2):void {
			var loot:WeaponUpgradeLootDrop;
			if(UnusedWeapons.length > 0) {
				loot = UnusedWeapons.pop();
			} else {
				loot = new WeaponUpgradeLootDrop();
			}
			
			loot.Reassign(location);
			layer.addChild(loot);
			
			UsedWeapons.push(loot);
		}
		
		public function SpawnAmmoAt(location:b2Vec2):void {
			var loot:AmmoLootDrop;
			if(UnusedAmmo.length > 0) {
				loot = UnusedAmmo.pop();
			} else {
				loot = new AmmoLootDrop();
			}
			
			loot.Reassign(location);
			layer.addChild(loot);
			
			UsedAmmo.push(loot);
		}
		
		public function Update(dt:Number):void {
			var i:int;
			
			for (i = 0; i < UsedWeapons.length; i++) {
				UsedWeapons[i].Update(dt);
				
				if (UsedWeapons[i].ShouldDeactivate()) {
					UsedWeapons[i].Deactivate();
					layer.removeChild(UsedWeapons[i]);
					
					UnusedWeapons.push(UsedWeapons.splice(i, 1)[0]);
					i--;
				}
			}
			
			for (i = 0; i < UsedAmmo.length; i++) {
				UsedAmmo[i].Update(dt);
				
				if (UsedAmmo[i].ShouldDeactivate()) {
					UsedAmmo[i].Deactivate();
					layer.removeChild(UsedAmmo[i]);
					
					UnusedAmmo.push(UsedAmmo.splice(i, 1)[0]);
					i--;
				}
			}
		}
		
	}

}