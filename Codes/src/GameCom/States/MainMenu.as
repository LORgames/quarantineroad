package GameCom.States {
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import GameCom.Helpers.AudioStore;
	import GameCom.SystemComponents.SettingsPane;
	import GameCom.SystemMain;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
	public class MainMenu extends Sprite {
		//Buttons and stuff?
		private var background:Bitmap;
		
		private const totalButtons:int = 1;
		private const buttonPadding:int = 10;
		
		private var TextContainer:Sprite = new Sprite();
		private var PlayText:TextField = new TextField();
		private var WebsiteText:TextField = new TextField();
		
		private var settings:SettingsPane = new SettingsPane();
		
		public function MainMenu() {
			//Just make sure we're ready to do this...
			if (this.stage) Init();
			else addEventListener(Event.ADDED_TO_STAGE, Init, false, 0, true);
		}
		
		public function Init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			this.addChild(settings);
			settings.x = 100;
			settings.y = 200;
			
			//Start Menu
			this.addChild(TextContainer);
			
			PlayText.selectable = false;
			PlayText.defaultTextFormat = new TextFormat("Verdana", 36, 0xFFFFFF);
			PlayText.autoSize = TextFieldAutoSize.CENTER;
			PlayText.text = "Play";
			PlayText.addEventListener(MouseEvent.ROLL_OVER, MouseOverText);
			PlayText.addEventListener(MouseEvent.ROLL_OUT, MouseOutText);
			PlayText.addEventListener(MouseEvent.CLICK, PlayFunc, false, 0, true);
			TextContainer.addChild(PlayText);
			
			WebsiteText.selectable = false;
			WebsiteText.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
			WebsiteText.autoSize = TextFieldAutoSize.CENTER;
			WebsiteText.text = "www.lorgames.com";
			WebsiteText.addEventListener(MouseEvent.ROLL_OVER, MouseOverText);
			WebsiteText.addEventListener(MouseEvent.ROLL_OUT, MouseOutText);
			WebsiteText.addEventListener(MouseEvent.CLICK, WebsiteFunc, false, 0, true);
			TextContainer.addChild(WebsiteText);
			
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
			
			this.graphics.clear();
			this.graphics.beginFill(0x0);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			
			var bmp:Bitmap = new Preloader.Logo() as Bitmap;
			var mat:Matrix = new Matrix(1, 0, 0, 1, (stage.stageWidth - bmp.width) / 2, (stage.stageHeight - bmp.height) / 2);

			this.graphics.beginBitmapFill(bmp.bitmapData, mat, false, false);
			this.graphics.drawRect((stage.stageWidth - bmp.width) / 2, (stage.stageHeight - bmp.height) / 2, bmp.width, bmp.height);
			this.graphics.endFill();
			
			TextContainer.x = mat.tx + 448 + 261/2;
			TextContainer.y = mat.ty + 241;
			
			PlayText.x = -PlayText.width/2;
			PlayText.y = 15;
			WebsiteText.x = -WebsiteText.width / 2;
			WebsiteText.y = PlayText.y + PlayText.height + 30;
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