package GameCom.States {
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import GameCom.Helpers.AudioStore;
	import GameCom.SystemMain;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import LORgames.Components.BitmapButton;
	import LORgames.Components.Button;
	import LORgames.Components.TextBox;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import LORgames.Engine.Storage;
	import LORgames.Localization.Strings;
	import mx.core.BitmapAsset;
	
	/**
	 * ...
	 * @author P. Fox
	 * @version 1
	 */
	public class EndGame extends Sprite {
		//Buttons and stuff?
		private var background:Sprite = new Sprite();
		
		private var RestartBtn:BitmapButton = new BitmapButton(211, 59, ThemeManager.Get("Interface/Start Button.png"), ThemeManager.Get("Interface/Restart Button Mouse Over.png"));
		private var MenuBtn:BitmapButton = new BitmapButton(211, 59, ThemeManager.Get("Interface/Trophies Button.png"), ThemeManager.Get("Interface/Trophies Button Mouse Over.png"));
		
		public function EndGame() {
			//Just make sure we're ready to do this...
			if (this.stage) Init();
			else addEventListener(Event.ADDED_TO_STAGE, Init, false, 0, true);
		}
		
		public function Init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			stage.focus = stage;
			
			background.graphics.beginBitmapFill(ThemeManager.Get("Interface/Restart Menu.png"));
			background.graphics.drawRect(0, 0, Global.SCREEN_WIDTH, 600);
			background.graphics.endFill();
			
			//Start Menu
			this.addChild(background);
			
			RestartBtn.addEventListener(MouseEvent.CLICK, RestartClicked, false, 0, true);
			this.addChild(RestartBtn);
			
			this.stage.addEventListener(Event.RESIZE, Resized, false, 0, true);
			Resized();
		}
		
		public function RestartClicked(e:MouseEvent):void {
			SystemMain.instance.StateTo(new GameScreen());
		}
		
		public function Resized(e:Event = null):void {
			if (!this.stage) return;
			
			background.x = (this.stage.stageWidth - background.width) / 2;
			background.y = (this.stage.stageHeight - background.height) / 2;
			
			RestartBtn.x = background.x + 18;
			RestartBtn.y = background.y + 230;
		}
		
		public function MouseOverText(e:MouseEvent):void {
			var textField:TextField = e.currentTarget as TextField;
			
			textField.filters = new Array(new GlowFilter(0x337C8C));
		}
		
		public function MouseOutText(e:MouseEvent):void {
			var textField:TextField = e.currentTarget as TextField;
			
			textField.filters = new Array();
		}
		
	}

}