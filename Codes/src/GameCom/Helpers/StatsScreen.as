package GameCom.Helpers 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	/**
	 * ...
	 * @author ...
	 */
	public class StatsScreen extends Sprite {
		
		private var titleScoresTF:TextField = new TextField();
		private var highScoresTF:TextField = new TextField();
		private var totalScoresTF:TextField = new TextField();
		
		public function StatsScreen() {
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
			
			this.addChild(titleScoresTF);
			this.addChild(highScoresTF);
			this.addChild(totalScoresTF);
		}
		
		private function Update(e:Event):void {
			iL.y -= 1;
			if (iL.y < -iL.height) {
				iL.y = iL.getChildAt(0).height;
			}
		}
		
	}

}