package GameCom.SystemComponents {
	import flash.display.Sprite;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author Paul
	 */
	public class HeartBar extends Sprite {
		public const GAP:int = 3;
		public const MAX:int = 5;
		
		public function HeartBar() {
			SetHealth(10);
		}
		
		public function SetHealth(newHP:int):void {
			for (var i:int = 0; i < MAX; i++) {
				if (newHP >= (i+1)*2) {
					this.graphics.beginBitmapFill(ThemeManager.Get("Hearts/Heart Full.png"), new Matrix(1, 0, 0, 1, (GAP + 12) * i, 0));
				} else if (newHP == i * 2 + 1) {
					this.graphics.beginBitmapFill(ThemeManager.Get("Hearts/Heart Half.png"), new Matrix(1, 0, 0, 1, (GAP + 12) * i, 0));
				} else {
					this.graphics.beginBitmapFill(ThemeManager.Get("Hearts/Heart Empty.png"), new Matrix(1, 0, 0, 1, (GAP + 12) * i, 0));
				}
				
				this.graphics.drawRect((GAP + 12) * i, 0, 12, 10);
				this.graphics.endFill();
			}
		}
		
	}

}