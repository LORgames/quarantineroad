package GameCom.Helpers 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class StatsScreen extends Sprite {
		
		private var instructions:Vector.<Bitmap> = new Vector.<Bitmap>();
		private var iL:Sprite = new Sprite();
		
		public function StatsScreen() {
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
			
			this.mask = new Bitmap(new BitmapData(178, 264, false, 0x0));
			this.addChild(this.mask);
		}
		
		private function init(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
			
			instructions.push(new Bitmap(ThemeManager.Get("Interface/Instruction 1.png")));
			instructions.push(new Bitmap(ThemeManager.Get("Interface/Instruction 2.png")));
			instructions.push(new Bitmap(ThemeManager.Get("Interface/Instruction 3.png")));
			instructions.push(new Bitmap(ThemeManager.Get("Interface/Instruction 4.png")));
			
			for (var i:int = 0; i < instructions.length; i++) {
				instructions[i].y = i * (instructions[i].height + 50);
				iL.addChild(instructions[i]);
			}
			
			this.addChild(iL);
			iL.y = iL.getChildAt(0).height;
		}
		
		private function Update(e:Event):void {
			iL.y -= 1;
			if (iL.y < -iL.height) {
				iL.y = iL.getChildAt(0).height;
			}
		}
		
	}

}