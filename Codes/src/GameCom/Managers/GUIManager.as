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
	import GameCom.GameComponents.Weapons.IWeapon;
	import GameCom.Helpers.AudioStore;
	import GameCom.Helpers.MathHelper;
	import GameCom.Helpers.ScoreHelper;
	import GameCom.Helpers.SpriteHelper;
	import GameCom.SystemComponents.HeartBar;
	import GameCom.SystemComponents.WeaponUIPanel;
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
		public static var I:GUIManager;
		
		private var PopupSprite:Sprite = new Sprite();
		private var Overlay:Sprite = new Sprite();
		
		public var Hearts:HeartBar = new HeartBar();
		public var Score:TextField = new TextField();
		
		private var ScoreValue:int = 0;
		
		private var MuteButton:Button = new Button("Mute", 20, 20, 6);
		
		private var Pause:Function;
		private var MockUpdateWorld:Function;
		
		public var Weapons:Vector.<WeaponUIPanel> = new Vector.<WeaponUIPanel>();
		
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
			
			Resize();
		}
		
		public function Update() : void {
			if (stage == null) return;
			
			Score.text = ScoreHelper.Score.Value.toString();
			
			Score.x = (stage.stageWidth - Score.width) / 2;
			Score.y = 30;
			
			for (var i:int = 0; i < Weapons.length; i++) {
				Weapons[i].Draw();
			}
		}
		
		public function RedrawWeapons() : void {
			if (stage == null) return;
			
			for (var i:int = 0; i < Weapons.length; i++) {
				Weapons[i].FullRedraw();
			}
		}
		
		private function MuteClicked(me:MouseEvent):void {
			AudioController.SetMuted(!AudioController.GetMuted());
		}
		
		public function AddWeapons(newWeps:Vector.<IWeapon>):void {
			for (var i:int = 0; i < newWeps.length; i++) {
				var wui:WeaponUIPanel = new WeaponUIPanel(newWeps[i]);
				this.addChild(wui);
				Weapons.push(wui);
			}
			
			Update();
		}
		
		public function Resize():void {
			if (stage == null) return;
			
			Hearts.x = (stage.stageWidth - Hearts.width) / 2;
			Hearts.y = 15;
			
			for (var i:int = 0; i < Weapons.length; i++) {
				Weapons[i].x = (stage.stageWidth - WeaponUIPanel.TILE_WIDTH * Weapons.length) / 2 + WeaponUIPanel.TILE_WIDTH * i;
				Weapons[i].y = stage.stageHeight - WeaponUIPanel.TILE_HEIGHT;
				//Weapons[i].x = stage.stageWidth - WeaponUIPanel.TILE_WIDTH;
				//Weapons[i].y = WeaponUIPanel.TILE_HEIGHT*i;
				Weapons[i].FullRedraw();
			}
		}
		
	}

}