package GameCom.Helpers 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.globalization.CurrencyFormatter;
	/**
	 * ...
	 * @author Paul
	 */
	public class AnimatedSprite extends Sprite {
		private var currentInterval:Number = 0;
		private var currentFrame:int = 0;
		
		private var startFrame:int = 0;
		private var endFrame:int = 1;
		
		private var playbackSpeed:Number = 0.5;
		
		private var frames:Vector.<BitmapData> = new Vector.<BitmapData>();
		
		private var sizeX:int = 0;
		private var sizeY:int = 0;
		
		public function AnimatedSprite() {
			
		}
		
		public function AddFrame(bmpd:BitmapData):void {
			frames.push(bmpd);
			
			sizeX = bmpd.width;
			sizeY = bmpd.height;
		}
		
		public function ChangePlayback(newPlaybackSpeed:Number = 0.5, newStartFrame:int = 0, frameDuration:int = 1):void {
			playbackSpeed = newPlaybackSpeed;
			startFrame = newStartFrame;
			endFrame = newStartFrame + frameDuration;
			
			currentFrame = startFrame;
		}
		
		public function Update(dt:Number):void {
			currentInterval += dt;
			
			while (currentInterval > playbackSpeed) {
				currentInterval -= playbackSpeed;
				currentFrame++;
				
				if (currentFrame == endFrame) {
					currentFrame = startFrame;
				}
			}
			
			this.graphics.clear();
			
			this.graphics.beginBitmapFill(frames[currentFrame], null, false);
			this.graphics.drawRect(0, 0, sizeX, sizeY);
			this.graphics.endFill();
		}
		
	}

}