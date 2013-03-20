package GameCom.SystemComponents {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Storage;
	/**
	 * ...
	 * @author Paul
	 */
	public class PauseButton extends Sprite {
		private var GetPaused:Function;
		private var Pause:Function;
		
		public function PauseButton(pause:Function, getpaused:Function) {
			GetPaused = getpaused;
			Pause = pause;
			
			Redraw();
			this.addEventListener(MouseEvent.CLICK, Clicked, false, 0, true);
		}
		
		public function Redraw():void {
			this.graphics.clear();
			
			if(!GetPaused()) this.graphics.beginBitmapFill(ThemeManager.Get("Interface/play button.png"));
			else this.graphics.beginBitmapFill(ThemeManager.Get("Interface/play button.png"));
			
			this.graphics.drawRect(0, 0, 29, 26);
			this.graphics.endFill();
		}
		
		private function Clicked(me:*):void {
			Pause();
			Redraw();
		}
		
	}

}