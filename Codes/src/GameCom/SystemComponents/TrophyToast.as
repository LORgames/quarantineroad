package GameCom.SystemComponents 
{
	import flash.display.Bitmap;
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
	public class TrophyToast extends Sprite {
		private const OPENING:int = 0;
		private const HOLDING:int = 1;
		private const CLOSING:int = 2;
		
		private static var I_:TrophyToast;
		
		public static function get I():TrophyToast {
			if (I_ == null) {
				I_ = new TrophyToast();
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
		
		public function TrophyToast() {
			I_ = this;
			this.addEventListener(Event.ADDED_TO_STAGE, Added);
			
			Main.GetStage().addChild(this);
		}
		
		public function Added(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, Added);
			
			this.y = 100;
			
			item = new Bitmap();
			item.x = 40;
			item.y = 11;
			
			overlay = new Bitmap(ThemeManager.Get("Interface/achievement unlocked left side.png"));
			underlap = new Bitmap(ThemeManager.Get("Interface/achievement unlocked right side.png"));
			
			text = new TextField();
			text.embedFonts = true;
			text.defaultTextFormat = new TextFormat("Visitor", 20, 0xFFFFFF);
			text.filters = new Array(new GlowFilter(0x0, 1, 7, 7, 3));
			text.text = "";
			text.autoSize = TextFieldAutoSize.LEFT;
			text.selectable = false;
			text.x = 17;
			text.y = 59;
			text.width = 100;
			text.wordWrap = true;
			
			this.addChild(tab);
			this.addChild(overlay);
			
			tab.addChild(underlap);
			tab.addChild(text);
			tab.addChild(item);
			
			tab.x = -107;
			tab.y = 6;
			
			//Do some things.
		}
		
		public function Update(e:Event):void {
			if(state == HOLDING) {
				if (direction > 0) {
					tab.x += direction;
					
					if (tab.x > 0) {
						tab.x = 0;
						direction = 0;
					}
				} else if (direction < 0) {
					tab.x += direction;
					
					if (tab.x < -150) {
						tab.x = -150;
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
				this.x += 2;
				if (this.x >= 0) {
					this.x = 0;
					state = HOLDING;
				}
			} else if (state == CLOSING) {
				this.x -= 2;
				
				if (this.x < -20) {
					this.x = -20;
					stage.removeEventListener(Event.ENTER_FRAME, Update);
				}
			}
		}
		
		private function ShowNext():void {
			if (currentlyShowing == -1) {
				if(messages.length > 0) {
					currentlyShowing = messages.pop();
					waited_time = 0;
					stage.addEventListener(Event.ENTER_FRAME, Update);
					
					text.text = TrophyHelper.GetTrophyName(currentlyShowing);
					item.bitmapData = ThemeManager.Get(TrophyHelper.GetTrophyPictureName(currentlyShowing));
					
					direction = 5;
					
					if(state == CLOSING) {
						state = OPENING;
					}
				} else {
					state = CLOSING;
				}
			}
		}
		
		public function AddTrophy(id:int):void {
			messages.push(id);
			ShowNext();
		}
		
	}

}