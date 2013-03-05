package GameCom.Helpers {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	/**
	 * ...
	 * @author Paul
	 */
	public class MenuDoorHelper extends Sprite {
		
		private var leftDoor:Bitmap;
		private var rightDoor:Bitmap;
		private var overlay:Bitmap;
		
		public function MenuDoorHelper() {
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			leftDoor = new Bitmap(ThemeManager.Get("Interface/LeftDoor.png"));
			rightDoor = new Bitmap(ThemeManager.Get("Interface/RightDoor.png"));
			overlay = new Bitmap(ThemeManager.Get("Interface/MenuOverlay.png"));
			
			this.addChild(leftDoor);
			this.addChild(rightDoor);
			this.addChild(overlay);
			
			stage.addEventListener(Event.ENTER_FRAME, Update);
		}
		
		private function CleanUp():void {
			stage.removeEventListener(Event.ENTER_FRAME, Update);
			this.parent.removeChild(this);
		}
		
		private function Update(e:Event):void {
			if (leftDoor.x > -leftDoor.width) {
				leftDoor.x -= 5;
				rightDoor.x += 5;
			} else {
				CleanUp();
			}
		}
		
	}

}