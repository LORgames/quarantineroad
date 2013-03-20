package GameCom.SystemComponents {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GameCom.Helpers.TrophyHelper;
	/**
	 * ...
	 * @author Paul
	 */
	public class WeaponToast extends Sprite {
		private const OPENING:int = 0;
		private const HOLDING:int = 1;
		private const CLOSING:int = 2;
		
		private static var I_:WeaponToast;
		
		public static function get I():WeaponToast {
			if (I_ == null) {
				I_ = new WeaponToast();
			}
			
			return I_;
		}
		
		private var state:int = CLOSING;
		
		private var messages:Array = new Array();
		
		private const WAIT_TIME:Number = 2;
		private var waited_time:Number = 0;
		private var direction:Number = -5;
		
		private var currentlyShowing:int = -1;
		
		private var overlay:Bitmap;
		private var tab:Sprite = new Sprite();
		
		private var underlap:Bitmap;
		private var item:Bitmap;
		private var text:TextField;
		
		public function WeaponToast() {
			I_ = this;
			this.addEventListener(Event.ADDED_TO_STAGE, Added);
			
			Main.GetStage().addChild(this);
		}
		
		public function Added(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, Added);
			
			this.y = 100;
			this.x = stage.stageWidth + 20;
			
			item = new Bitmap();
			item.x = 50;
			item.y = 11;
			
			overlay = new Bitmap(ThemeManager.Get("Interface/weapon side.png"));
			underlap = new Bitmap(ThemeManager.Get("Interface/weapon side2.png"));
			
			text = new TextField();
			text.embedFonts = true;
			text.defaultTextFormat = new TextFormat("Visitor", 16, 0xFFFFFF);
			text.filters = new Array(new GlowFilter(0x0, 1, 7, 7, 3));
			text.text = "";
			text.autoSize = TextFieldAutoSize.CENTER;
			text.selectable = false;
			text.x = 26;
			text.y = 59;
			text.width = 100;
			text.wordWrap = true;
			
			overlay.x = -overlay.width;
			
			this.addChild(tab);
			this.addChild(overlay);
			
			tab.addChild(underlap);
			tab.addChild(text);
			tab.addChild(item);
			
			tab.x = -30;
			tab.y = 6;
			
			//Do some things.
		}
		
		public function Update(e:Event):void {
			if (!stage) return;
			
			if(state == HOLDING) {
				if (direction > 0) { //OPENING
					tab.x -= direction;
					
					if (tab.x < -tab.width) {
						tab.x = -tab.width;
						direction = 0;
					}
				} else if (direction < 0) {
					tab.x -= direction; //CLOSING
					
					if (tab.x > -30) {
						tab.x = -30;
						direction = 0;
						
						currentlyShowing = -1;
						ShowNext();
					}
				} else {
					waited_time += Global.TIME_STEP;
					
					if (waited_time > WAIT_TIME) {
						direction = -5;
					}
				}
			} else if (state == OPENING) {
				this.x -= 2;
				
				if (this.x < stage.stageWidth) {
					this.x = stage.stageWidth;
					state = HOLDING;
				}
			} else if (state == CLOSING) {
				this.x += 2;
				
				if (this.x >= stage.stageWidth + 30) {
					this.x = stage.stageWidth + 30;
					stage.removeEventListener(Event.ENTER_FRAME, Update);
				}
			}
		}
		
		private function ShowNext():void {
			if (currentlyShowing == -1) {
				if (messages.length > 0) {
					currentlyShowing = 1;
					waited_time = 0;
					stage.addEventListener(Event.ENTER_FRAME, Update);
					
					item.bitmapData = messages.pop();
					text.text = messages.pop();
					
					text.x = 26;
					
					direction = 5;
					
					if(state == CLOSING) {
						state = OPENING;
					}
				} else {
					state = CLOSING;
				}
			}
		}
		
		public function AddWeaponPickup(text:String, bmp:BitmapData):void {
			messages.push(text);
			messages.push(bmp);
			
			ShowNext();
		}
		
	}

}