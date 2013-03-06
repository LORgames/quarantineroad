package GameCom.Helpers {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Paul
	 */
	public class MenuBackgroundHelper extends Sprite {
		
		private var dancers:Vector.<AnimatedSprite> = new Vector.<AnimatedSprite>();
		private var offset:int = 0;
		
		public function MenuBackgroundHelper() {
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
			
			this.mask = new Bitmap(new BitmapData(Global.SCREEN_WIDTH, Global.SCREEN_WIDTH, false, 0x0));
			this.addChild(this.mask);
		}
		
		private function init(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
			
			for (var i:int = 1; i < 8; i++) {
				for (var j:int = 0; j < 8; j++) {
					dancers.push(CreateZombie(50 * i + (Math.random()-0.5) * 30, 50 * j + (Math.random()-0.5) * 30));
				}
			}
		}
		
		private function Update(e:Event):void {
			offset += 1;
			
			var bmpd:BitmapData = (ThemeManager.Get("Terrain/Road.png") as BitmapData);
			
			if (offset > bmpd.height) {
				offset -= bmpd.height;
			}
			
			this.graphics.clear();
			this.graphics.beginBitmapFill(bmpd, new Matrix(1, 0, 0, 1, 0, offset));
			this.graphics.drawRect(0, 0, Global.SCREEN_WIDTH, Global.SCREEN_WIDTH);
			this.graphics.endFill();
			
			for (var i:int = 0; i < dancers.length; i++) {
				dancers[i].Update(Global.TIME_STEP);
				dancers[i].y += 2;
				
				if (dancers[i].y > 350) {
					dancers[i].y = -40;
				}
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
			
			while (Math.random() > 0.2) {
				animation.Update(Math.random());
			}
			
			this.addChild(animation);
			
			return animation;
		}
		
	}

}