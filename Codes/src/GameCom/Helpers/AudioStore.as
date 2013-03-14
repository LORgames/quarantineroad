package GameCom.Helpers 
{
	/**
	 * ...
	 * @author ...
	 */
	public class AudioStore {
		//{ region Embeds
		[Embed(source="../../../lib/Audio/Music.mp3")]
		public static const Music:Class;
		
		[Embed(source="../../../lib/Audio/UI/MenuPopup.mp3")]
		public static const MenuPopup:Class;
		
		[Embed(source="../../../lib/Audio/UI/MenuClickSound.mp3")]
		public static const MenuClick:Class;
		
		[Embed(source="../../../lib/Audio/Explode.mp3")]
		public static const Explode:Class;
		
		[Embed(source = "../../../lib/Audio/Footsteps/1.mp3")]
		public static const Footstep1:Class;
		
		[Embed(source = "../../../lib/Audio/Footsteps/2.mp3")]
		public static const Footstep2:Class;
		
		[Embed(source = "../../../lib/Audio/Footsteps/3.mp3")]
		public static const Footstep3:Class;
		
		[Embed(source = "../../../lib/Audio/Footsteps/4.mp3")]
		public static const Footstep4:Class;
		
		[Embed(source = "../../../lib/Audio/Footsteps/5.mp3")]
		public static const Footstep5:Class;
		
		[Embed(source = "../../../lib/Audio/MetalHits/1.mp3")]
		public static const MetalHit1:Class;
		
		[Embed(source = "../../../lib/Audio/MetalHits/2.mp3")]
		public static const MetalHit2:Class;
		
		[Embed(source = "../../../lib/Audio/MetalHits/3.mp3")]
		public static const MetalHit3:Class;
		
		[Embed(source = "../../../lib/Audio/MetalHits/4.mp3")]
		public static const MetalHit4:Class;
		
		[Embed(source = "../../../lib/Audio/MetalHits/5.mp3")]
		public static const MetalHit5:Class;
		
		[Embed(source = "../../../lib/Audio/MetalHits/6.mp3")]
		public static const MetalHit6:Class;
		
		[Embed(source = "../../../lib/Audio/MetalHits/7.mp3")]
		public static const MetalHit7:Class;
		
		[Embed(source = "../../../lib/Audio/MetalHits/8.mp3")]
		public static const MetalHit8:Class;
		
		[Embed(source = "../../../lib/Audio/MetalHits/9.mp3")]
		public static const MetalHit9:Class;
		
		[Embed(source = "../../../lib/Audio/MetalHits/10.mp3")]
		public static const MetalHit10:Class;
		
		[Embed(source = "../../../lib/Audio/MetalHits/11.mp3")]
		public static const MetalHit11:Class;
		
		[Embed(source = "../../../lib/Audio/Shotgun/1.mp3")]
		public static const ShotgunFire1:Class;
		
		[Embed(source = "../../../lib/Audio/Sniper/sniper 2.mp3")]
		public static const SniperFire1:Class;
		
		[Embed(source = "../../../lib/Audio/Grenade Launcher/grenade launcher 2.mp3")]
		public static const GrenadeLauncher1:Class;
		
		[Embed(source = "../../../lib/Audio/Chain Lightning Gun/electric zap.mp3")]
		public static const ChainLightningGun1:Class;
		
		[Embed(source = "../../../lib/Audio/Shotgun/reload.mp3")]
		public static const ShotgunReload:Class;
		
		[Embed(source = "../../../lib/Audio/ZombieSounds/2.mp3")]
		public static const ZombieSound2:Class;
		
		[Embed(source = "../../../lib/Audio/ZombieSounds/3.mp3")]
		public static const ZombieSound3:Class;
		
		[Embed(source = "../../../lib/Audio/ZombieSounds/4.mp3")]
		public static const ZombieSound4:Class;
		
		[Embed(source = "../../../lib/Audio/ZombieSounds/5.mp3")]
		public static const ZombieSound5:Class;
		
		[Embed(source = "../../../lib/Audio/ZombieSounds/6.mp3")]
		public static const ZombieSound6:Class;
		
		[Embed(source = "../../../lib/Audio/ZombieSounds/7.mp3")]
		public static const ZombieSound7:Class;
		//} endregion
		
		public static var ZombieSounds:Array = new Array(ZombieSound2, ZombieSound3, ZombieSound4, ZombieSound5, ZombieSound6, ZombieSound7);
		public static var FootstepSounds:Array = new Array(Footstep1, Footstep2, Footstep3, Footstep4, Footstep5);
		public static var ShotgunFire:Array = new Array(ShotgunFire1);
		
		public static function GetZombieSound():Class {
			return ZombieSounds[int(ZombieSounds.length * Math.random())];
		}
		
		public static function GetFootstepSound():Class {
			return FootstepSounds[int(FootstepSounds.length * Math.random())];
		}
		
		public static function GetShotgunFireSound():Class {
			return ShotgunFire[int(ShotgunFire.length * Math.random())];
		}
	}

}