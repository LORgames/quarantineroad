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
	public class BigExplosion extends Sprite implements IExplosion {
		
		private var animation:AnimatedSprite;
		private var endTime:int = 0;
		
		public function BigExplosion() {
			animation = new AnimatedSprite();
			animation.AddFrame(ThemeManager.Get("Explosion/exp00.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/exp01.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/exp02.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/exp03.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/exp04.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/exp05.png"));
			animation.AddFrame(ThemeManager.Get("Explosion/exp06.png"));
			
			animation.Update(0);
			this.addChild(animation);
			
			animation.x = -animation.width / 2;
			animation.y = -animation.height / 2;
		}
		
		public function Reset():void {
			animation.ChangePlayback(0.1, 0, 7, true);
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