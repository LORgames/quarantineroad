package GameCom.GameComponents.Loot {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flash.display.Sprite;
	import GameCom.GameComponents.Weapons.IWeapon;
	import GameCom.Helpers.BodyHelper;
	import GameCom.Helpers.SpriteHelper;
	import GameCom.Managers.WorldManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class WeaponUpgradeLootDrop extends LootDrop {
		private var type:int = 0;
		
		public function WeaponUpgradeLootDrop() {
			this.addChild(SpriteHelper.CreateCenteredBitmapData(ThemeManager.Get("Loot/EmptyLoot.png")));
		}
		
		public override function Reassign(location:b2Vec2):void {
			super.Reassign(location);
		}
		
		public override function Pickup(equipment:Vector.<IWeapon>):void {
			equipment[type].Upgrade();
			super.Pickup(equipment);
		}
	}

}