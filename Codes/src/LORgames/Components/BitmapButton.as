package LORgames.Components {
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author PaulFox
	 * @version 3
	 * Changed to protected so can be overriden elsewhere
	 */
	public class BitmapButton extends MovieClip {
		private var m_w:int;
		private var m_h:int;
		
		private var standard:BitmapData;
		private var rollOver:BitmapData;
		
		public function BitmapButton(width:int, height:int, standardButton:BitmapData, rollOverButton:BitmapData) {
			this.standard = standardButton;
			this.rollOver = rollOverButton;
			
			this.size(width, height);
			
			Prepare();
		}
		
		protected function Prepare():void {
			this.stop();
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.ROLL_OVER, highlighted);
			this.addEventListener(MouseEvent.ROLL_OUT, released);
			this.addEventListener(MouseEvent.MOUSE_UP, released);
		}
		
		public function move(newX:int, newY:int):void {
			this.x = newX;
			this.y = newY;
		}
		
		public function size(newWidth:int, newHeight:int):void {
			m_w = newWidth;
			m_h = newHeight;
			
			draw();
		}
		
		public function draw(mouseOn:Boolean = false):void {
			this.graphics.clear();
			
			this.graphics.beginBitmapFill((mouseOn?rollOver:standard), null, true, true);
			this.graphics.drawRect(0, 0, m_w, m_h);
			this.graphics.endFill();
		}
		
		protected function highlighted(me:MouseEvent = null):void {
			draw(true);
		}
		
		protected function released(me:MouseEvent = null):void {
			draw(false);
		}
		
		public function disable():void {
			this.mouseEnabled = false;
			this.enabled = false;
		}
		
		public function enable():void {
			this.mouseEnabled = true;
			this.enabled = true;
		}
		
	}

}