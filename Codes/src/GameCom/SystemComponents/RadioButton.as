package GameCom.SystemComponents 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Paul
	 */
	public class RadioButton extends Sprite {
		
		private var mode:Boolean = false;
		
		public function RadioButton() {
			Redraw();
		}
		
		public function On():void {
			mode = true;
			Redraw();
		}
		
		public function Off():void {
			mode = false;
			Redraw();
		}
		
		private function Redraw():void {
			this.graphics.clear();
			
			if (mode) {
				this.graphics.beginBitmapFill(ThemeManager.Get("Interface/TickedCircle.png"));
			} else {
				this.graphics.beginBitmapFill(ThemeManager.Get("Interface/UntickedCircle.png"));
			}
			
			this.graphics.drawRect(0, 0, 10, 10);
			this.graphics.endFill();
		}
		
	}

}