package GameCom.States {
	import flash.display.MovieClip;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.TrophyHelper;
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
		private var Zombie:MovieClip = new MovieClip();
		
		public function WorldPreparation() {
			//Just make sure we're ready to do this...
			if (this.stage) Init();
			else addEventListener(Event.ADDED_TO_STAGE, Init, false, 0, true);
		}
		
		public function Init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			//Start Menu
			PercentageText.embedFonts = true;
			PercentageText.selectable = false;
			PercentageText.defaultTextFormat = new TextFormat("Visitor", 40, 0xFFFFFF);
			PercentageText.autoSize = TextFieldAutoSize.CENTER;
			PercentageText.text = "0.00%";
			this.addChild(PercentageText);
			
			DisplayText.embedFonts = true;
			DisplayText.selectable = false;
			DisplayText.defaultTextFormat = new TextFormat("Visitor", 16, 0xFFFFFF);
			DisplayText.autoSize = TextFieldAutoSize.CENTER;
			DisplayText.text = "Preparing Assets...";
			this.addChild(DisplayText);
			
			Zombie = new Preloader.WalkingZombie();
			this.addChild(Zombie);
			
			this.stage.addEventListener(Event.RESIZE, Resized, false, 0, true);
			Resized();
			
			ThemeManager.Initialize(CreateWorldNow, UpdatePercentageLoaded);
		}
		
		public function CreateWorldNow():void {
			WorldManager.Initialize();
			
			//AudioController.PlayLoop(AudioStore.Music);
			
			WorldManager.World.Step(0, 1, 1);
			
			Stats.Connect();
			
			TrophyHelper.TotalTrophies();
			if(Stats.GetInt("Gameplays", 0) > 0) TrophyHelper.GotTrophyByName("Back for Maaaw");
			
			SystemMain.instance.StateTo(new MainMenu());
		}
		
		public function Resized(e:Event = null):void {
			if (!this.stage) return;
			
			this.graphics.clear();
			this.graphics.beginFill(0x0);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			
			PercentageText.x = this.stage.stageWidth/2 - PercentageText.width / 2;
			PercentageText.y = this.stage.stageHeight/2 + 100;
			
			DisplayText.x = this.stage.stageWidth/2 - DisplayText.width / 2;
			DisplayText.y = this.stage.stageHeight / 2 + 60;
			
			Zombie.x = this.stage.stageWidth/2;
			Zombie.y = this.stage.stageHeight/2;
		}
		
		public function UpdatePercentageLoaded(newPercent:String):void {
			PercentageText.text = newPercent + "%";
		}
		
	}

}