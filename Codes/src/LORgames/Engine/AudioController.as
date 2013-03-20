package LORgames.Engine 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	/**
	 * ...
	 * @author P. Fox
	 * @version 1
	 */
	public class AudioController {
		//All sounds currently playing
		private static var loopsPlaying:Vector.<SoundChannel> = new Vector.<SoundChannel>();
		private static var quickPlaying:Vector.<SoundChannel> = new Vector.<SoundChannel>();
		
		//Mute bool
		private static var muted:Boolean = false;
		
		public static function GetMuted():Boolean {
			return muted;
		};
		
		public static function SetMuted(b:Boolean):void {
			muted = b;
			
			var tr:SoundTransform = new SoundTransform();
			var vol:Number = new Number(!muted);
			
			var s:SoundChannel;
			
			for each (s in loopsPlaying) {
				if (s == null) continue;
				
				tr = s.soundTransform;
				tr.volume = vol;
				s.soundTransform = tr;
			}
			
			for each (s in quickPlaying) {
				if (s == null) continue;
				
				tr = s.soundTransform;
				tr.volume = vol;
				s.soundTransform = tr;
			}
			
			Storage.SaveSetting("isMuted", b);
		}
		
		/**
		 * Plays a sound file from a URL once
		 * @param filename the url to play the sound from
		 */
		public static function PlaySound(soundCLS:Class):void {
			//Check that the system has the capability to play audio
			if (Capabilities.hasAudio && !GetMuted()) {
				var mySound:Sound = new soundCLS();
				var channel:SoundChannel = null;
				
				try {
					channel = mySound.play(0, 1, new SoundTransform(0.5));
					channel.addEventListener(Event.SOUND_COMPLETE, soundFinished);
					
					quickPlaying.push(channel);
				} catch(e:Error) {
					
				}
			}
		}
		
		public static function PlayLoop(soundCLS:Class, hasVolume:Boolean = true):SoundChannel {
			//Check that the system has the capability to play audio
			if (Capabilities.hasAudio) {
				var mySound:Sound = new soundCLS();
				var channel:SoundChannel = null;
				channel = mySound.play(0, int.MAX_VALUE, new SoundTransform((hasVolume?(GetMuted()?0:1):0)));
				
				loopsPlaying.push(channel);
				
				return channel;
			}
			
			return null;
		}
		
		public static function FadeOut(sound:SoundChannel):void {
			if (sound == null) return;
			
			var mt:SoundTransform = sound.soundTransform;
			mt.volume = 0.0;
			sound.soundTransform = mt;
		}
		
		public static function FadeIn(sound:SoundChannel):void {
			if (sound == null) return;
			if (GetMuted()) return;
			
			var mt:SoundTransform = sound.soundTransform;
			mt.volume = 1.0;
			sound.soundTransform = mt;
		}
		
		private static function soundFinished(e:Event):void {
			quickPlaying.splice(quickPlaying.indexOf(e.target), 1);
		}
		
	}

}