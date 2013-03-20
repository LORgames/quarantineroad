package GameCom.Helpers 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import GameCom.SystemComponents.RadioButton;
	/**
	 * ...
	 * @author ...
	 */
	public class InstructionsHelper extends Sprite {
		
		private var radios:Vector.<RadioButton> = new Vector.<RadioButton>();
		private var instructions:Vector.<Bitmap> = new Vector.<Bitmap>();
		private var iL:Sprite = new Sprite();
		
		public function InstructionsHelper() {
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
			
			this.mask = new Bitmap(new BitmapData(185, 264, false, 0x0));
			this.addChild(this.mask);
		}
		
		private function init(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			instructions.push(new Bitmap(ThemeManager.Get("Interface/Instruction 1.png")));
			instructions.push(new Bitmap(ThemeManager.Get("Interface/Instruction 2.png")));
			instructions.push(new Bitmap(ThemeManager.Get("Interface/Instruction 3.png")));
			instructions.push(new Bitmap(ThemeManager.Get("Interface/Instruction 4.png")));
			
			this.addChild(iL);
			
			for (var i:int = 0; i < instructions.length; i++) {
				instructions[i].x = i * (instructions[i].width + 20);
				iL.addChild(instructions[i]);
				
				var r:RadioButton = new RadioButton();
				
				r.addEventListener(MouseEvent.ROLL_OVER, rollOver);
				r.x = 185 - (12 * instructions.length) + 12 * i;
				r.y = 3;
				this.addChild(r);
				
				radios.push(r);
			}
			
			radios[0].On();
		}
		
		private function rollOver(me:MouseEvent):void {
			for (var i:int = 0; i < radios.length; i++) {
				if (radios[i] == me.currentTarget) {
					radios[i].On();
					iL.x = -i * (instructions[i].width + 20)
				} else {
					radios[i].Off();
				}
			}
		}
		
	}

}