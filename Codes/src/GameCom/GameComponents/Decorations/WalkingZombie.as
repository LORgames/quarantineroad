package GameCom.GameComponents.Decorations 
{
	import GameCom.Helpers.AnimatedSprite;
	/**
	 * ...
	 * @author Paul
	 */
	public class WalkingZombie {
		[Embed(source = "../../../../lib/EmbeddedArt/z0.png")]
		private var f0:Class;
		[Embed(source = "../../../../lib/EmbeddedArt/z1.png")]
		private var f1:Class;
		[Embed(source = "../../../../lib/EmbeddedArt/z2.png")]
		private var f2:Class;
		[Embed(source = "../../../../lib/EmbeddedArt/z3.png")]
		private var f3:Class;
		[Embed(source = "../../../../lib/EmbeddedArt/z4.png")]
		private var f4:Class;
		[Embed(source = "../../../../lib/EmbeddedArt/z5.png")]
		private var f5:Class;
		[Embed(source = "../../../../lib/EmbeddedArt/z6.png")]
		private var f6:Class;
		[Embed(source = "../../../../lib/EmbeddedArt/z7.png")]
		private var f7:Class;
		
		private var animation:AnimatedSprite = new AnimatedSprite();
		
		public function WalkingZombie() {
			animation = CreateZombie(0, 0);
		}
		
		public function CreateZombie(x:Number, y:Number):AnimatedSprite {
			var animation:AnimatedSprite = new AnimatedSprite();
			
			
			
			animation.x = x;
			animation.y = y;
			
			while (Math.random() > 0.2) {
				animation.Update(Math.random());
			}
			
			this.addChild(animation);
			
			return animation;
		}
	}

}