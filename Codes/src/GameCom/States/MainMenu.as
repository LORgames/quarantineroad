package GameCom.States {
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
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
		
		private var PlayText:Button = new Button("START", 195, 45, 10, null, true);
		private var WebsiteText:Button = new Button("WEBSITE", 200, 20, 10, null, true);
		
		public function MainMenu() {
			//Just make sure we're ready to do this...
			if (this.stage) Init();
			else addEventListener(Event.ADDED_TO_STAGE, Init, false, 0, true);
		}
		
		public function Init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			//Start Menu
			PlayText.addEventListener(MouseEvent.CLICK, PlayFunc, false, 0, true);
			this.addChild(PlayText);
			
			WebsiteText.addEventListener(MouseEvent.CLICK, WebsiteFunc, false, 0, true);
			this.addChild(WebsiteText);
			
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
			
			PlayText.x = mat.tx + 20;
			PlayText.y = mat.ty + 400;
			
			WebsiteText.x = (stage.stageWidth-WebsiteText.width) / 2;
			WebsiteText.y = mat.ty + 5;
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