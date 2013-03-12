package GameCom.Helpers {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
		
		private static var direction:int = 5;
		
		public function MenuDoorHelper() {
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
			
			this.mask = new Bitmap(new BitmapData(Global.SCREEN_WIDTH, Global.SCREEN_WIDTH, false, 0x0));
			this.addChild(this.mask);
		}
		
		private function init(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			leftDoor = new Bitmap(ThemeManager.Get("Interface/LeftDoor.png"));
			rightDoor = new Bitmap(ThemeManager.Get("Interface/RightDoor.png"));
			overlay = new Bitmap(ThemeManager.Get("Interface/MenuOverlay.png"));
			
			this.addChild(rightDoor);
			this.addChild(leftDoor);
			this.addChild(overlay);
			
			stage.addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
		}
		
		public function CleanUp():void {
			stage.removeEventListener(Event.ENTER_FRAME, Update);
			this.parent.removeChild(this);
		}
		
		private function Update(e:Event):void {
			if (leftDoor.x > -leftDoor.width && direction > 0) {
				leftDoor.x -= direction;
				rightDoor.x += direction;
			} else if (leftDoor.x < 0 && direction < 0) {
				leftDoor.x -= direction;
				rightDoor.x += direction;
			}
		}
		
		public function Switch():void {
			direction = -direction;
		}
		
	}

}