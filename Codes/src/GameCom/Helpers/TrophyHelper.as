package GameCom.Helpers 
{
	import GameCom.SystemComponents.TrophyToast;
	import LORgames.Engine.MessageBox;
	import LORgames.Engine.Storage;
	/**
	 * ...
	 * @author Paul
	 */
	public class TrophyHelper {
		private static const TrophyData:Array = new Array(
			"250m Run", "Move 250m in a single game.",
			"500m Run", "Move 500m in a single game.",
			"1000m Run", "Move 1000m in a single game.",
			
			"Pacifist", "Walk 100m without killing a zombie. Including Melee!",
			"Time", "Survive 3 minutes in a single game.",
			"Man vs Zombie", "Survive 6 minutes in a single game.",
			
			"Boomstick", "Get 150 kills with the shotgun in a single game.",
			"Crispy", "Get 250 kills with the flame thrower in a single game.",
			"Spray and Prey", "Kill 250 zombies with SMG or Dual SMG in a single game.",
			
			"Tesla's Pride", "Kill 500 zombies with the lightning gun in a single game.",
			"Fire in the Hole", "Kill 50 zombies with grenades or rockets in a single game.",
			"Ima Firin Mah Lazer", "Kill 250 zombies with the laser in a single game.", //needs to be changed
			
			"28 Plays Later", "Play the game 28 times.",
			"Back for Maaaw", "Reload the game after a break.",
			"New Shoes", "Walk through an acid pool and survive.",
			
			"My name is Hurl", "Kill 25 Vomit Zombies in a single game.",
			"Harlem Shake", "Kill 20 zombies while the screen is shaking in a single game.",
			"Headshot", "Kill 25 zombies from more then 25m away with the sniper rifle in a single game.",
			
			"Brain", "Kill at least 1 of each type of zombie in a single game.",
			"Don't Bite Me Bro", "Die without touching any zombies.",
			"High Five", "*SQUISH* Killed by the hand.",
			
			"Party Pooper", "Kill 5 zombies in a single Bloat Explosion.",
			"Close Call", "Pick up a health pack when on half a heart left.",
			"Max Ammo", "Obtain Full ammo for each type of weapon in a single game.",
			
			"Upgrade", "Find a weapon Upgrade.",
			"2 for 1", "Pick up a secondary pistol or SMG.",
			"Fully Loaded", "Obtain all weapon upgrades in a single game.",
			
			"Piece of Cake", "Kill 99 zombies in a single game.",
			"Zombie", "Kill 5000 zombies in total.",
			"Project Alice", "Kill 25000 zombies in total."
		);
		
		private static var trophyInfo:int = 0;
		
		public static function TotalTrophies():int {
			trophyInfo = Storage.GetAsInt("VARIABLE0");
			return int(TrophyData.length/2);
		}
		
		public static function HasTrophy(trophyID:int):Boolean {
			return ((0x1 << trophyID) & trophyInfo) > 0;
		}
		
		public static function GotTrophy(trophyID:int):void {
			if(!HasTrophy(trophyID)) {
				trophyInfo = (0x1 << trophyID) | trophyInfo;
				Storage.Set("VARIABLE0", trophyInfo);
				TrophyToast.I.AddTrophy(trophyID);
			}
		}
		
		public static function GetTrophyName(trophyID:int):String {
			return TrophyData[trophyID * 2];
		}
		
		public static function GetTrophyDescription(trophyID:int):String {
			return TrophyData[trophyID * 2 + 1];
		}
		
		public static function GetTrophyPictureName(trophyID:int):String {
			return "Trophies/" + TrophyData[trophyID * 2] + ".png";
		}
		
		public static function GotTrophyByName(name:String):void {
			for (var i:int = 0; i < TrophyData.length; i+=2) {
				if (TrophyData[i] == name) {
					GotTrophy(i / 2);
					return;
				}
			}
			
			new MessageBox("Could not find the trophy '" + name + "' please fix the codez.", 0);
		}
		
	}

}