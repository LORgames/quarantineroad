package GameCom.GameComponents.Loot {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import GameCom.GameComponents.PlayerCharacter;
	import GameCom.GameComponents.Weapons.IWeapon;
	import GameCom.Helpers.BodyHelper;
	import GameCom.Helpers.SpriteHelper;
	import GameCom.Helpers.TrophyHelper;
	import GameCom.Managers.GUIManager;
	import GameCom.Managers.LootManager;
	import GameCom.Managers.WorldManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class WeaponUpgradeLootDrop extends LootDrop {
		private var type:int = 0;
		
		public function WeaponUpgradeLootDrop() {
			//nothing special?
		}
		
		public override function Reassign(location:b2Vec2):void {
			var bmpd:BitmapData;
			
			for (var i:int = 0; i < 3; i++) {
				type = Math.random() * 8;
				bmpd = GUIManager.I.Weapons[type].Weapon.GetUpgradeIcon();
				
				if (bmpd != null) {
					break;
				}
			}
			
			if (bmpd == null) {
				pickedUP = true;
				
				if(Math.random() > 0.5) {
					LootManager.I.SpawnAmmoAt(location);
				} else {
					LootManager.I.SpawnHealthAt(location);
				}
				
				return;
			}
			
			while (item.numChildren > 0) item.removeChildAt(0);
			
			var bmp:Bitmap = new Bitmap(bmpd);
			bmp.x = -bmp.width / 2;
			bmp.y = -bmp.height;
			
			item.addChild(bmp);
			
			super.Reassign(location);
		}
		
		public override function Pickup(equipment:Vector.<IWeapon>, player:PlayerCharacter):void {
			trace("Upgraded: " + type);
			
			TrophyHelper.GotTrophyByName("Upgrade");
			
			equipment[type].Upgrade();
			
			GUIManager.I.RedrawWeapons();
			player.RedrawTopHalf();
			
			super.Pickup(equipment, player);
		}
	}

}