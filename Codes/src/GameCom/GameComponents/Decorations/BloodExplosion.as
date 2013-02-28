package GameCom.GameComponents.Decorations 
{
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Managers.WorldManager;
	/**
	 * ...
	 * @author Paul
	 */
	public class BloodExplosion extends Sprite implements IExplosion {
		
		private var animation:AnimatedSprite;
		
		public function BloodExplosion() {
			animation = new AnimatedSprite();
			animation.AddFrame(ThemeManager.Get("Blood/BloodSplatter0_0.png"));
			animation.AddFrame(ThemeManager.Get("Blood/BloodSplatter0_1.png"));
			
			animation.Update(0);
			this.addChild(animation);
			
			animation.x = -animation.width / 2;
			animation.y = -animation.height / 2;
		}
		
		public function Reset():void {
			animation.ChangePlayback(0.1, 0, 2, true);
		}
		
		public function IsFinished():Boolean {
			return animation.IsStopped();
		}
		
		public function Update(dt:Number):void {
			animation.Update(dt);
			this.y += WorldManager.WorldScrollSpeed * Global.PHYSICS_SCALE * dt;
		}
	}

}