package GameCom.SystemComponents 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import LORgames.Components.BitmapButton;
	/**
	 * ...
	 * @author Paul
	 */
	public class PauseScreen extends Sprite {
		
		private var pauseBtn:BitmapButton = new BitmapButton(195, 40, ThemeManager.Get("Interface/play button.png"), ThemeManager.Get("Interface/play button moused over.png"));
		private var clicked:Function;
		
		public function PauseScreen(_clicked:Function) {
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
			
			clicked = _clicked;
			
			this.addChild(pauseBtn);
			pauseBtn.addEventListener(MouseEvent.CLICK, Unpause, false, 0, true);
		}
		
		public function Init(e:Event):void {
			this.graphics.clear();
			this.graphics.beginFill(0x0, 0.8);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			
			pauseBtn.x = (stage.stageWidth - pauseBtn.width) / 2;
			pauseBtn.y = (stage.stageHeight + pauseBtn.height) / 2;
		}
		
		public function Unpause(me:MouseEvent):void {
			clicked();
		}
		
	}

}