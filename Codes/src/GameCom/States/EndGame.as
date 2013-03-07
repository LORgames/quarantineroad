package GameCom.States {
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import GameCom.Helpers.AnimatedSprite;
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
	import mochi.as3.MochiAd;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author P. Fox
	 * @version 1
	 */
	public class EndGame extends Sprite {
		//Buttons and stuff?
		private var background:Sprite = new Sprite();
		
		private var RestartBtn:BitmapButton = new BitmapButton(211, 59, ThemeManager.Get("Interface/Restart Button.png"), ThemeManager.Get("Interface/Restart Button Mouse Over.png"));
		private var MenuBtn:BitmapButton = new BitmapButton(211, 59, ThemeManager.Get("Interface/Menu Button.png"), ThemeManager.Get("Interface/Menu Button Mouse Over.png"));
		
		private var adContainer:MovieClip = new MovieClip();
		
		private var handAnimation:AnimatedSprite = new AnimatedSprite();
		
		private var score:int = 0;
		private var distance:int = 0;
		private var zombiekills:int = 0;
		
		public function EndGame(score:int, distance:String, zombiekills:int) {
			trace("S:" + score + " D:" + distance + " Z:" + zombiekills);
			
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
			
			//The hand thing
			this.addChild(handAnimation);
			
			//Start Menu
			this.addChild(background);
			
			RestartBtn.addEventListener(MouseEvent.CLICK, RestartClicked, false, 0, true);
			this.addChild(RestartBtn);
			
			MenuBtn.addEventListener(MouseEvent.CLICK, MenuClicked, false, 0, true);
			this.addChild(MenuBtn);
			
			adContainer.x = 72; adContainer.y = 335;
			this.addChild(adContainer);
			
			//TODO: ENABLE ADS
			MochiAd.showClickAwayAd( { clip:adContainer, id:"5a3aaf31eb62a90e" } );
			//.showPreGameAd({clip:adContainer, id:"5a3aaf31eb62a90e", res:stage.stageWidth+"x"+stage.stageHeight, ad_finished:fAdFinished, no_progress_bar:true});
			
			handAnimation.AddFrame(ThemeManager.Get("Zombies/Hand/0_5.png"));
			handAnimation.AddFrame(ThemeManager.Get("Zombies/Hand/0_6.png"));
			handAnimation.AddFrame(ThemeManager.Get("Zombies/Hand/0_7.png"));
			handAnimation.AddFrame(ThemeManager.Get("Zombies/Hand/0_8.png"));
			handAnimation.AddFrame(ThemeManager.Get("Zombies/Hand/0_7.png"));
			handAnimation.AddFrame(ThemeManager.Get("Zombies/Hand/0_6.png"));
			handAnimation.ChangePlayback(0.1, 0, 6);
			handAnimation.Update(0);
			
			this.stage.addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
			this.stage.addEventListener(Event.RESIZE, Resized, false, 0, true);
			
			Resized();
		}
		
		public function Update(e:*):void {
			handAnimation.Update(Global.TIME_STEP);
		}
		
		public function RestartClicked(e:MouseEvent):void {
			SystemMain.instance.StateTo(new GameScreen());
		}
		
		public function MenuClicked(e:MouseEvent):void {
			SystemMain.instance.StateTo(new MainMenu());
		}
		
		public function Resized(e:Event = null):void {
			if (!this.stage) return;
			
			background.x = (this.stage.stageWidth - background.width) / 2;
			background.y = (this.stage.stageHeight - background.height) / 2;
			
			RestartBtn.x = background.x + 18;
			RestartBtn.y = background.y + 230;
			
			MenuBtn.x = background.x + 223;
			MenuBtn.y = background.y + 230;
			
			handAnimation.x = (stage.stageWidth - handAnimation.width) / 2;
			handAnimation.y = background.y + 35;
			
			adContainer.x = background.x + 72;
			adContainer.y = background.y + 335;
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