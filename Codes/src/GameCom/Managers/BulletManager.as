package GameCom.Managers 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	import flash.events.DRMCustomProperties;
	import GameCom.GameComponents.Projectiles.BasicBullet;
	import GameCom.GameComponents.Projectiles.IBullet;
	import GameCom.GameComponents.Weapons.IWeapon;
	/**
	 * ...
	 * @author Paul
	 */
	public class BulletManager {
		public static var I:BulletManager;
		
		private var UsedBullets:Vector.<IBullet> = new Vector.<IBullet>();
		
		private var UnusedBullets_Generic:Vector.<IBullet> = new Vector.<IBullet>();
		private var UnusedBullets_BasicBullet:Vector.<IBullet> = new Vector.<IBullet>();
		
		private var layer:Sprite;
		
		public function BulletManager(layer:Sprite) {
			I = this;
			this.layer = layer;
		}
		
		public function FireAt(location:b2Vec2, bulletType:Class, owner:IWeapon, angle:Number = 0, distance:Number = 0, damage:Number = 0):void {
			var bulletUsed:IBullet;
			
			switch(bulletType){
				case BasicBullet:
					if (UnusedBullets_BasicBullet.length > 0) {
						bulletUsed = UnusedBullets_BasicBullet.pop();
					}
					
					break;
				default:
					for (var i:int = 0; i < UnusedBullets_Generic.length; i++) {
						if (UnusedBullets_Generic[i] is bulletType) {
							bulletUsed = UnusedBullets_Generic.splice(i, 1)[0];
							break;
						}
					}
					break;
			}
			
			if (!bulletUsed) {
				bulletUsed = new bulletType();
			}
			
			bulletUsed.SetLocationAndActivate(location, owner, layer, angle, distance, damage);
			UsedBullets.push(bulletUsed);
		}
		
		public function Update(dt:Number):void {
			for (var i:int = 0; i < UsedBullets.length; i++) {
				UsedBullets[i].Update(dt);
				
				if (UsedBullets[i].ShouldRemove()) {
					if (UsedBullets[i] is BasicBullet) {
						UnusedBullets_BasicBullet.push(UsedBullets[i]);
					} else {
						UnusedBullets_Generic.push(UsedBullets[i]);
					}
					
					UsedBullets[i].Deactivate(layer);
					UsedBullets.splice(i, 1);
					i--;
				}
			}
		}
		
	}

}