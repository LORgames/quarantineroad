package GameCom.GameComponents.Loot 
{
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
	public class WeaponUpdateLootDrop extends LootDrop {
		private var type:int = 0;
		
		public function WeaponUpdateLootDrop() {
			this.addChild(SpriteHelper.CreateCenteredBitmapData(ThemeManager.Get("Loot/EmptyLoot.png")));
		}
		
		public override function Reassign(location:b2Vec2, type:int):void {
			body.SetPosition(location);
			body.SetActive(true);
			
			this.type = type;
			
			pickedUP = false;
		}
		
		public override function Pickup(equipment:Vector.<IWeapon>):void {
			equipment[type].AddAmmo();
			pickedUP = true;
		}
	}

}