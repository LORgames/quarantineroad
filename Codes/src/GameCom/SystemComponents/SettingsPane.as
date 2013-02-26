package GameCom.SystemComponents {
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Storage;
	/**
	 * ...
	 * @author Paul
	 */
	public class SettingsPane extends Sprite {
		
		private var SettingsHeaderTF:TextField;
		
		private var SoundOnLabel:TextField;
		private var SoundOnText:TextField;
		private var SoundOffText:TextField;
		
		private const PANE_HEIGHT:int = 200;
		
		public function SettingsPane() {
			this.graphics.beginFill(0x0, 0.7);
			this.graphics.lineStyle(2);
			
			this.graphics.drawRoundRect(0, 0, 274, PANE_HEIGHT, 20);
			this.graphics.endFill();
			
			SettingsHeaderTF = GenerateTextfield(36, "Settings", [new GlowFilter(0x337C8C, 1, 10, 10, 5, 1)], true, -20);
			
			/////////////////////////// SOUND
			AudioController.SetMuted(Storage.GetSetting("isMuted"));
			
			SoundOnLabel = GenerateTextfield(18, "Sound on or off?", [], true, 90);
			
			SoundOnText = GenerateTextfield(16, "On", [], true, 115);
			SoundOnText.x = 274 / 2 - SoundOnText.width - 10;
			FilterSetting(SoundOnText, !AudioController.GetMuted());
			GenerateListeners(SoundOnText, SoundOnMouseOver, SoundOnMouseClick, SoundOnMouseLeave);
			
			SoundOffText = GenerateTextfield(16, "Off", [], true, 115);
			SoundOffText.x = 274 / 2 + 10;
			FilterSetting(SoundOffText, AudioController.GetMuted());
			GenerateListeners(SoundOffText, SoundOffMouseOver, SoundOffMouseClick, SoundOffMouseLeave);
		}
		
		private function GenerateTextfield(size:int, text:String, filters:Array = null, center:Boolean = true, yPos:int = 0):TextField {
			var tf:TextField = new TextField();
			
			tf.selectable = false;
			tf.defaultTextFormat = new TextFormat("Verdana", size, 0xFFFFFF);
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.text = text;
			tf.filters = filters;
			
			if (center) {
				tf.x = (274 - tf.width) / 2;
			}
			
			tf.y = yPos;
			
			this.addChild(tf);
			
			return tf;
		}
		
		private function FilterSetting(tf:TextField, isOn:Boolean):void {
			if (!isOn) tf.filters = [];
			else tf.filters = [new GlowFilter(0x337C8C, 1, 10, 10, 5, 1)];
		}
		
		private function GenerateListeners(tf:TextField, mouseOver:Function, clickFunc:Function, mouseLeave:Function):void {
			tf.addEventListener(MouseEvent.CLICK, clickFunc, false, 0, true);
			tf.addEventListener(MouseEvent.ROLL_OVER, mouseOver, false, 0, true);
			tf.addEventListener(MouseEvent.ROLL_OUT, mouseLeave, false, 0, true);
		}
		
		private function SoundOnMouseOver(me:MouseEvent):void { if (AudioController.GetMuted()) SoundOnText.filters = [new GlowFilter(0x7C8C33, 1, 10, 10, 5, 1)]; }
		private function SoundOnMouseClick(me:MouseEvent):void { if (AudioController.GetMuted()) { AudioController.SetMuted(false); Storage.SaveSetting("isMuted", false); FilterSetting(SoundOnText, true); FilterSetting(SoundOffText, false);} }
		private function SoundOnMouseLeave(me:MouseEvent):void { if (AudioController.GetMuted()) SoundOnText.filters = []; }
		
		private function SoundOffMouseOver(me:MouseEvent):void { if (!AudioController.GetMuted()) SoundOffText.filters = [new GlowFilter(0x7C8C33, 1, 10, 10, 5, 1)]; }
		private function SoundOffMouseClick(me:MouseEvent):void { if (!AudioController.GetMuted()) { AudioController.SetMuted(true); Storage.SaveSetting("isMuted", true); FilterSetting(SoundOffText, true); FilterSetting(SoundOnText, false);} }
		private function SoundOffMouseLeave(me:MouseEvent):void { if (!AudioController.GetMuted()) SoundOffText.filters = []; }
		
	}

}