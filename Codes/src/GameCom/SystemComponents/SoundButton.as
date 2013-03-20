package GameCom.SystemComponents {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Storage;
	/**
	 * ...
	 * @author Paul
	 */
	public class SoundButton extends Sprite {
		[Embed(source = "../../../lib/EmbeddedArt/mute.png")]
		public var mute:Class;
		
		[Embed(source = "../../../lib/EmbeddedArt/unmute.png")]
		public var unmute:Class;
		
		public function SoundButton() {
			AudioController.SetMuted(Storage.GetSetting("isMuted"));
			Redraw();
			
			this.addEventListener(MouseEvent.CLICK, Clicked);
		}
		
		public function Redraw():void {
			if (this.numChildren > 0) {
				this.removeChildAt(0);
			}
			
			if (Storage.GetSetting("isMuted")) {
				this.addChild(new mute());
			} else {
				this.addChild(new unmute());
			}
		}
		
		private function Clicked(me:*):void {
			var currentSetting:Boolean = Storage.GetSetting("isMuted");
			Storage.SaveSetting("isMuted", !currentSetting);
			Redraw();
			
			AudioController.SetMuted(!currentSetting);
		}
		
	}

}