package GameCom.Helpers 
{
	/**
	 * ...
	 * @author ...
	 */
	public class AudioStore {
		[Embed(source="../../../lib/Audio/Music.mp3")]
		public static const Music:Class;
		
		[Embed(source="../../../lib/Audio/MenuPopup.mp3")]
		public static const MenuPopup:Class;
		
		[Embed(source="../../../lib/Audio/MenuClickSound.mp3")]
		public static const MenuClick:Class;
		
		[Embed(source="../../../lib/Audio/Explode.mp3")]
		public static const Explode:Class;
	}

}