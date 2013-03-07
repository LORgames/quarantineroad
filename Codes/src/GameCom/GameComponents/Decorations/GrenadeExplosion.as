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
	public class GrenadeExplosion extends Sprite implements IExplosion {
		
		private var animation:AnimatedSprite;
		private var endTime:int = 0;
		
		public function GrenadeExplosion() {
			animation = new AnimatedSprite();
			animation.AddFrame(ThemeManager.Get("Explosion/bomb00.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/bomb01.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/bomb02.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/bomb03.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/bomb04.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/bomb05.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/bomb06.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/bomb07.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/bomb08.png"));
			
			animation.Update(0);
			this.addChild(animation);
			
			animation.x = -101;
			animation.y = -130;
		}
		
		public function Reset():void {
			animation.ChangePlayback(0.08, 0, 9, true);
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