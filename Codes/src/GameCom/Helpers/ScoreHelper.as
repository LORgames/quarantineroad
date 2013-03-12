package GameCom.Helpers 
{
	import mochi.as3.MochiDigits;
	/**
	 * ...
	 * @author Paul
	 */
	public class ScoreHelper {
		//Score systems
		public static var Score:MochiDigits;
		public static var Distance:MochiDigits;
		public static var Time:MochiDigits;
		
		//Zombie kill stats
		public static var AllKills:MochiDigits;
		
		public static var SlowKills:MochiDigits;
		public static var LimpKills:MochiDigits;
		public static var RedKills:MochiDigits;
		public static var BlueKills:MochiDigits;
		public static var ThrowUpKills:MochiDigits;
		public static var HandKills:MochiDigits;
		public static var ExplosiveKills:MochiDigits;
		public static var HulkKills:MochiDigits;
		
		public static function Reset():void {
			Score = new MochiDigits();
			Distance = new MochiDigits();
			Time = new MochiDigits();
			
			AllKills = new MochiDigits();
			SlowKills = new MochiDigits();
			LimpKills = new MochiDigits();
			RedKills = new MochiDigits();
			BlueKills = new MochiDigits();
			ThrowUpKills = new MochiDigits();
			ExplosiveKills = new MochiDigits();
			HulkKills = new MochiDigits();
		}
		
		
	}

}