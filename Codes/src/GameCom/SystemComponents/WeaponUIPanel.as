package GameCom.SystemComponents {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GameCom.GameComponents.Weapons.IWeapon;
	/**
	 * ...
	 * @author Paul
	 */
	public class WeaponUIPanel extends Sprite {
		public static const TILE_WIDTH:Number = 62.5;
		public static const TILE_HEIGHT:int = 40;
		
		private var Weapon:IWeapon;
		private var info:TextField;
		
		public function WeaponUIPanel(weapon:IWeapon) {
			this.Weapon = weapon;
			
			info = new TextField();
			info.embedFonts = true;
			info.defaultTextFormat = new TextFormat("Visitor", 20, 0xFFFFFF);
			info.filters = new Array(new GlowFilter(0x0, 1, 2, 2, 5));
			info.text = "0";
			info.autoSize = TextFieldAutoSize.LEFT;
			info.selectable = false;
			this.addChild(info);
		}
		
		public function Draw():void {
			info.text = Weapon.GetAmmoReadout();
			info.x = (TILE_WIDTH - info.width) / 2;
		}
		
		public function FullRedraw():void {
			this.graphics.clear();
			
			if(Weapon.IsActive()) {
				this.graphics.beginFill(0xFFC0C0, 0.3);
			} else {
				this.graphics.beginFill(0xFFFFFF, 0.3);
			}
				
			this.graphics.drawRect(0, 0, TILE_WIDTH, TILE_HEIGHT);
			this.graphics.endFill();
			
			var bmpd:BitmapData = Weapon.GetIcon();
			this.graphics.beginBitmapFill(bmpd, new Matrix(1, 0, 0, 1, (TILE_WIDTH - bmpd.width) / 2, 2), false, true);
			this.graphics.drawRect((TILE_WIDTH - bmpd.width) / 2, 2, bmpd.width, bmpd.height);
			this.graphics.endFill();
			
			info.text = Weapon.GetAmmoReadout();
			info.x = (TILE_WIDTH - info.width) / 2;
			info.y = TILE_HEIGHT - info.height;
		}
		
	}

}