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
	public class LootDrop extends Sprite {
		private var body:b2Body;
		private var speed:b2Vec2 = new b2Vec2();
		
		private var type:int = 0;
		private var pickedUP:Boolean = false;
		
		public function LootDrop() {
			body = BodyHelper.GetGenericCircle(0.25, Global.PHYSICS_CATEGORY_LOOT, this);
			body.GetFixtureList().SetSensor(true);
			body.SetActive(false);
			
			this.addChild(SpriteHelper.CreateCenteredBitmapData(ThemeManager.Get("Loot/BasicWeapon.png")));
		}
		
		public function Update(dt:Number):void {
			speed.y = WorldManager.WorldScrollSpeed;
			body.SetLinearVelocity(speed);
			
			this.x = body.GetPosition().x * Global.PHYSICS_SCALE;
			this.y = body.GetPosition().y * Global.PHYSICS_SCALE;
		}
		
		public function Reassign(location:b2Vec2, type:int):void {
			body.SetPosition(location);
			body.SetActive(true);
			
			this.type = type;
			
			pickedUP = false;
		}
		
		public function Deactivate():void {
			body.SetActive(false);
		}
		
		public function ShouldDeactivate():Boolean {
			if (pickedUP) return true;
			return (this.y > stage.stageHeight + 50);
		}
		
		public function Pickup(equipment:Vector.<IWeapon>):void {
			equipment[type].AddAmmo();
			pickedUP = true;
		}
	}

}