package GameCom.States {
	import flash.display.BitmapData;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.InstructionsHelper;
	import GameCom.Helpers.MenuBackgroundHelper;
	import GameCom.SystemComponents.TrophyMenu;
	import GameCom.SystemMain;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import LORgames.Components.BitmapButton;
	import LORgames.Components.Button;
	import LORgames.Components.TextBox;
	import LORgames.Components.Tooltip;
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
	public class MainMenu extends Sprite {
		//Buttons and stuff?
		private var background:Sprite = new Sprite();
		
		private var StartBtn:BitmapButton = new BitmapButton(211, 59, ThemeManager.Get("Interface/Start Button.png"), ThemeManager.Get("Interface/Start Button Mouse Over.png"));
		private var WebsiteText:Button = new Button("WEBSITE", 200, 20, 10, null, true);
		
		private var mbh:MenuBackgroundHelper = new MenuBackgroundHelper();
		private var tooltip:Tooltip = new Tooltip("", Tooltip.UP, 20, 175);
		
		private var trophies:TrophyMenu = new TrophyMenu(tooltip);
		private var instructions:InstructionsHelper = new InstructionsHelper();
		
		public function MainMenu() {
			//Just make sure we're ready to do this...
			if (this.stage) Init();
			else addEventListener(Event.ADDED_TO_STAGE, Init, false, 0, true);
		}
		
		public function Init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			this.addChild(mbh);
			this.addChild(background);
			this.addChild(trophies);
			
			//Start Menu
			StartBtn.addEventListener(MouseEvent.CLICK, PlayFunc, false, 0, true);
			this.addChild(StartBtn);
			
			WebsiteText.addEventListener(MouseEvent.CLICK, WebsiteFunc, false, 0, true);
			this.addChild(WebsiteText);
			
			this.addChild(tooltip);
			this.addChild(instructions);
			
			this.stage.addEventListener(Event.RESIZE, Resized, false, 0, true);
			Resized();
		}
		
		public function PlayFunc(e:MouseEvent):void {
			AudioController.PlaySound(AudioStore.MenuClick);
			SystemMain.instance.StateTo(new GameScreen());
		}
		
		public function WebsiteFunc(e:MouseEvent):void {
			AudioController.PlaySound(AudioStore.MenuClick);
			flash.net.navigateToURL(new URLRequest("http://www.lorgames.com"), "_blank");
		}
		
		public function Resized(e:Event = null):void {
			if (!this.stage) return;
			
			var bmp:BitmapData = ThemeManager.Get("Interface/NewMenu.png");
			var mat:Matrix = new Matrix(1, 0, 0, 1, (stage.stageWidth - bmp.width) / 2, (stage.stageHeight - bmp.height) / 2);
			
			background.graphics.clear();
			background.graphics.beginBitmapFill(bmp, mat, false, false);
			background.graphics.drawRect((stage.stageWidth - bmp.width) / 2, (stage.stageHeight - bmp.height) / 2, bmp.width, bmp.height);
			background.graphics.endFill();
			
			StartBtn.x = mat.tx + 0;
			StartBtn.y = mat.ty + 223
			;
			
			WebsiteText.x = (stage.stageWidth-WebsiteText.width) / 2;
			WebsiteText.y = mat.ty + 5;
			
			trophies.x = mat.tx + 213;
			trophies.y = mat.ty + 35;
			
			instructions.x = mat.tx + 302;
			instructions.y = mat.ty + 303;
			
			mbh.x = mat.tx;
			mbh.y = mat.ty;
		}
		
	}

}