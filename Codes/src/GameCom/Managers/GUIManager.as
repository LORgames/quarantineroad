package GameCom.Managers {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.MathHelper;
	import GameCom.Helpers.SpriteHelper;
	import GameCom.SystemComponents.HeartBar;
	import LORgames.Components.Button;
	import LORgames.Components.Tooltip;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import LORgames.Engine.Mousey;
	/**
	 * ...
	 * @author Paul
	 */
	public class GUIManager extends Sprite {
		[Embed(source="../../../lib/visitor1.ttf", fontName="Visitor", embedAsCFF=false)]
		private static var fontName:Class;

		public static var I:GUIManager;
		
		private var PopupSprite:Sprite = new Sprite();
		private var Overlay:Sprite = new Sprite();
		
		public var Hearts:HeartBar = new HeartBar();
		public var Score:TextField = new TextField();
		
		private var ScoreValue:int = 0;
		
		private var MuteButton:Button = new Button("Mute", 20, 20, 6);
		
		private var Pause:Function;
		private var MockUpdateWorld:Function;
		
		public function GUIManager(pauseLoopback:Function, mockupdate:Function) {
			I = this;
			
			this.addChild(Overlay);
			this.addChild(PopupSprite);
			this.addChild(Hearts);
			
			Score.embedFonts = true;
			Score.defaultTextFormat = new TextFormat("Visitor", 20, 0xFFFFFF);
			Score.filters = new Array(new GlowFilter(0x0, 1, 7, 7, 3));
			Score.text = "";
			Score.autoSize = TextFieldAutoSize.LEFT;
			Score.selectable = false;
			this.addChild(Score);
			
			this.addChild(MuteButton);
			MuteButton.addEventListener(MouseEvent.CLICK, MuteClicked, false, 0, true);
			MuteButton.alpha = 0;
		}
		
		public function Update() : void {
			if (stage == null) return;
			
		}
		
		public function UpdateScore(score:int):void {
			ScoreValue += score;
			Score.text = ScoreValue.toString();
			
			Score.x = (stage.stageWidth - Score.width) / 2;
			Score.y = 30;
		}
		
		private function MuteClicked(me:MouseEvent):void {
			AudioController.SetMuted(!AudioController.GetMuted());
		}
		
	}

}