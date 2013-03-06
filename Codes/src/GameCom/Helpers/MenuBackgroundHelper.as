package GameCom.Helpers {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Paul
	 */
	public class MenuBackgroundHelper extends Sprite {
		
		private var dancers:Vector.<AnimatedSprite> = new Vector.<AnimatedSprite>();
		
		public function MenuBackgroundHelper() {
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
			
			for (var i:int = 0; i < 9; i++) {
				for (var j:int = 0; j < 7; j++) {
					dancers.push(CreateZombie(50 * i, 50 * j));
				}
			}
		}
		
		private function Update(e:Event):void {
			for (var i:int = 0; i < dancers.length; i++) {
				dancers[i].Update(Global.TIME_STEP);
			}
		}
		
		public function CreateZombie(x:Number, y:Number):AnimatedSprite {
			var animation:AnimatedSprite = new AnimatedSprite();
			
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie/0_0.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie/0_1.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie/0_2.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie/0_3.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie/0_4.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie/0_5.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie/0_6.png"));
			animation.AddFrame(ThemeManager.Get("Zombies/Base Zombie/0_7.png"));
			animation.ChangePlayback(0.1, 0, 8);
			
			animation.x = x;
			animation.y = y;
			
			//while (Math.random() > 0.2) {
				//animation.Update(Math.random());
			//}
			
			this.addChild(animation);
			
			return animation;
		}
		
	}

}