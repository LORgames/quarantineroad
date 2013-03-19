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
	import GameCom.Managers.WorldManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class AmmoLootDrop extends LootDrop {
		private var type:int = 0;
		
		public function AmmoLootDrop() {
			var bmpd:BitmapData = ThemeManager.Get("WeaponIcons/ammo.png");
			
			var bmp:Bitmap = new Bitmap(bmpd);
			bmp.x = -bmp.width / 2;
			bmp.y = -bmp.height;
			
			item.addChild(bmp);
		}
		
		public override function Pickup(equipment:Vector.<IWeapon>, player:PlayerCharacter):void {
			var giveTrophy:Boolean = true;
			
			for (var i:int = 0; i < equipment.length; i++) {
				equipment[i].AddAmmo();
				
				if (giveTrophy && !equipment[i].IsMaxAmmo()) {
					giveTrophy = false;
				}
			}
			
			if (giveTrophy) {
				TrophyHelper.GotTrophyByName("Max Ammo");
			}
			
			super.Pickup(equipment, player);
		}
	}

}