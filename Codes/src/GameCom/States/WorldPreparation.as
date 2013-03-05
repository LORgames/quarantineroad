package GameCom.States {
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import GameCom.Helpers.AudioStore;
	import GameCom.Managers.WorldManager;
	import GameCom.SystemMain;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import LORgames.Components.Button;
	import LORgames.Components.TextBox;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import LORgames.Engine.Stats;
	import LORgames.Engine.Storage;
	import LORgames.Localization.Strings;
	import mx.core.BitmapAsset;
	
	/**
	 * ...
	 * @author P. Fox
	 * @version 1
	 */
	public class WorldPreparation extends Sprite {
		//Buttons and stuff?
		private var background:Bitmap;
		private const buttonPadding:int = 10;
		
		private var DisplayText:TextField = new TextField();
		private var PercentageText:TextField = new TextField();
		
		public function WorldPreparation() {
			//Just make sure we're ready to do this...
			if (this.stage) Init();
			else addEventListener(Event.ADDED_TO_STAGE, Init, false, 0, true);
		}
		
		public function Init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			background = new Preloader.Logo();
			
			//Start Menu
			this.addChild(background);
			
			PercentageText.selectable = false;
			PercentageText.defaultTextFormat = new TextFormat("Verdana", 40, 0xFFFFFF);
			PercentageText.autoSize = TextFieldAutoSize.CENTER;
			PercentageText.text = "0.00%";
			this.addChild(PercentageText);
			
			DisplayText.selectable = false;
			DisplayText.defaultTextFormat = new TextFormat("Verdana", 16, 0xFFFFFF);
			DisplayText.autoSize = TextFieldAutoSize.CENTER;
			DisplayText.text = "Preparing Assets...";
			this.addChild(DisplayText);
			
			this.stage.addEventListener(Event.RESIZE, Resized, false, 0, true);
			Resized();
			
			ThemeManager.Initialize(CreateWorldNow, UpdatePercentageLoaded);
		}
		
		public function CreateWorldNow():void {
			WorldManager.Initialize();
			
			//AudioController.PlayLoop(AudioStore.Music);
			
			WorldManager.World.Step(0, 1, 1);
			
			Stats.Connect();
			
			SystemMain.instance.StateTo(new MainMenu());
		}
		
		public function Resized(e:Event = null):void {
			if (!this.stage) return;
			
			this.graphics.clear();
			this.graphics.beginFill(0x0);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			
			background.x = (this.stage.stageWidth - background.width) / 2;
			background.y = (this.stage.stageHeight - background.height) / 2;
			
			PercentageText.x = background.x + 330 - PercentageText.width / 2;
			PercentageText.y = background.y + 510;
			
			DisplayText.x = background.x + 230 - DisplayText.width / 2;
			DisplayText.y = background.y + 415;
		}
		
		public function UpdatePercentageLoaded(newPercent:String):void {
			PercentageText.text = newPercent + "%";
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