package GameCom.States {
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import GameCom.Helpers.AnimatedSprite;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.ScoreHelper;
	import GameCom.Helpers.TrophyHelper;
	import GameCom.Managers.GUIManager;
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
	import LORgames.Engine.Stats;
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
		private var road:Sprite = new Sprite();
		private var background:Sprite = new Sprite();
		
		private var RestartBtn:BitmapButton = new BitmapButton(211, 59, ThemeManager.Get("Interface/Restart Button.png"), ThemeManager.Get("Interface/Restart Button Mouse Over.png"));
		private var MenuBtn:BitmapButton = new BitmapButton(211, 59, ThemeManager.Get("Interface/Menu Button.png"), ThemeManager.Get("Interface/Menu Button Mouse Over.png"));
		
		private var adContainer:MovieClip = new MovieClip();
		
		private var handAnimation:AnimatedSprite = new AnimatedSprite();
		
		private var score:String = "";
		private var distance:String = "";
		private var zombiekills:String = "";
		
		private var scoreTF:TextField;
		private var distanceTF:TextField;
		private var zombiekillsTF:TextField;
		
		public function EndGame() {
			this.score = ScoreHelper.Score.Value.toFixed(0);
			this.distance = ScoreHelper.Distance.Value.toFixed(2);
			this.zombiekills = ScoreHelper.AllKills.Value.toFixed(0);
			
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
			
			road.graphics.beginBitmapFill(ThemeManager.Get("Terrain/Road.png"));
			road.graphics.drawRect(0, 0, Global.SCREEN_WIDTH, 300);
			road.graphics.endFill();
			
			//The road
			this.addChild(road);
			
			//The hand thing
			this.addChild(handAnimation);
			
			//Start Menuo
			this.addChild(background);
			
			RestartBtn.addEventListener(MouseEvent.CLICK, RestartClicked, false, 0, true);
			this.addChild(RestartBtn);
			
			MenuBtn.addEventListener(MouseEvent.CLICK, MenuClicked, false, 0, true);
			this.addChild(MenuBtn);
			
			this.addChild(adContainer);
			
			//TODO: ENABLE ADS
			MochiAd.showClickAwayAd( { clip:adContainer, id:"5a3aaf31eb62a90e", ad_failed:ShowDeliveranceAd, ad_skipped:ShowDeliveranceAd } );
			
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
			
			scoreTF = CreateTextField(score + " <font color='#9DD2D0'>points</font>");
			distanceTF = CreateTextField(distance + " <font color='#D0CB4C'>meters run</font>");
			zombiekillsTF = CreateTextField(zombiekills + " <font color='#64C24B'>zombies slain</font>");
			
			Resized();
			
			//////////////////////////////////////////////////////////////////////////////////////////
			//SET SOME STATS
			//////////////////////////////////////////////////////////////////////////////////////////
			
			//Update highscores
			Storage.DisableSave();
			Stats.SetHighestInt("HighestScore", ScoreHelper.Score.Value);
			Stats.SetHighestInt("HighestDistance", ScoreHelper.Distance.Value);
			Stats.SetHighestInt("LongestTime", ScoreHelper.Time.Value*100);
			
			Stats.SetHighestInt("TotalKillsHigh", ScoreHelper.AllKills.Value);
			Stats.SetHighestInt("MeleeKillsHigh", ScoreHelper.MeleeKills.Value);
			Stats.SetHighestInt("ShakeyKillsHigh", ScoreHelper.ShakeyKills.Value);
			
			Stats.SetHighestInt("SlowKillsHigh", ScoreHelper.SlowKills.Value);
			Stats.SetHighestInt("LimpKillsHigh", ScoreHelper.LimpKills.Value);
			Stats.SetHighestInt("BlueKillsHigh", ScoreHelper.BlueKills.Value);
			Stats.SetHighestInt("RedKillsHigh", ScoreHelper.RedKills.Value);
			Stats.SetHighestInt("HulkKillsHigh", ScoreHelper.HulkKills.Value);
			Stats.SetHighestInt("ExplosiveKillsHigh", ScoreHelper.ExplosiveKills.Value);
			Stats.SetHighestInt("ThrowUpKillsHigh", ScoreHelper.ThrowUpKills.Value);
			
			for (var i:int = 0; i < GUIManager.I.Weapons.length; i++) {
				GUIManager.I.Weapons[i].Weapon.ReportStatistics();
			}
			
			//Add to the totals
			Stats.AddValue("TotalScore", ScoreHelper.Score.Value);
			Stats.AddValue("TotalDistance", ScoreHelper.Distance.Value);
			Stats.AddValue("TotalTime", ScoreHelper.Time.Value*100);
			
			Stats.AddValue("TotalKills", ScoreHelper.AllKills.Value);
			Stats.AddValue("MeleeKills", ScoreHelper.MeleeKills.Value);
			Stats.AddValue("ShakeyKills", ScoreHelper.ShakeyKills.Value);
			
			Stats.AddValue("SlowKillsTotal", ScoreHelper.SlowKills.Value);
			Stats.AddValue("LimpKillsTotal", ScoreHelper.LimpKills.Value);
			Stats.AddValue("BlueKillsTotal", ScoreHelper.BlueKills.Value);
			Stats.AddValue("RedKillsTotal", ScoreHelper.RedKills.Value);
			Stats.AddValue("HulkKillsTotal", ScoreHelper.HulkKills.Value);
			Stats.AddValue("ExplosiveKillsTotal", ScoreHelper.ExplosiveKills.Value);
			Stats.AddValue("ThrowUpKillsTotal", ScoreHelper.ThrowUpKills.Value);
			Storage.EnableSave();
			Storage.Save();
			
			//PROCESS ACHIEVEMENTS
			if (ScoreHelper.MeleeKills.Value == 0) TrophyHelper.GotTrophyByName("Don't Bite Me Bro");
			
			//Process 'Brain' Achievement.
			if (ScoreHelper.BlueKills.Value > 0 &&
				ScoreHelper.ExplosiveKills.Value > 0 &&
				ScoreHelper.HulkKills.Value > 0 &&
				ScoreHelper.LimpKills.Value > 0 &&
				ScoreHelper.RedKills.Value > 0 &&
				ScoreHelper.SlowKills.Value > 0 &&
				ScoreHelper.ThrowUpKills.Value > 0) TrophyHelper.GotTrophyByName("Brain");
		}
		
		public function ShowDeliveranceAd():void {
			adContainer.addChild(new Bitmap(ThemeManager.Get("Interface/Deliverance Ad.png")));
			adContainer.addEventListener(MouseEvent.CLICK, ClickedDeliveranceAd, false, 0, true);
			adContainer.mouseEnabled = true;
			adContainer.buttonMode = true;
		}
		
		public function ClickedDeliveranceAd(e:*):void {
			flash.net.navigateToURL(new URLRequest("http://www.kongregate.com/games/LORgames/deliverance"), "_self");
		}
		
		public function CreateTextField(str:String):TextField {
			var info:TextField = new TextField();
			info.embedFonts = true;
			info.defaultTextFormat = new TextFormat("Visitor", 18, 0xFFFFFF);
			info.filters = new Array(new GlowFilter(0x3B3535, 1, 4, 4, 10));
			info.htmlText = str;
			info.autoSize = TextFieldAutoSize.LEFT;
			info.selectable = false;
			this.addChild(info);
			
			return info;
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
			
			road.x = background.x;
			road.y = background.y;
			
			RestartBtn.x = background.x + 38;
			RestartBtn.y = background.y + 230;
			
			MenuBtn.x = background.x + 254;
			MenuBtn.y = background.y + 230;
			
			handAnimation.x = (stage.stageWidth - handAnimation.width) / 2;
			handAnimation.y = background.y + 35;
			
			adContainer.x = background.x + 100;
			adContainer.y = background.y + 336;
			
			scoreTF.x = background.x + 225;
			scoreTF.y = background.y + 172;
			
			distanceTF.x = background.x + 225;
			distanceTF.y = background.y + 194;
			
			zombiekillsTF.x = background.x + 225;
			zombiekillsTF.y = background.y + 215;
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