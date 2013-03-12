package GameCom.Helpers 
{
	import mochi.as3.MochiDigits;
	/**
	 * ...
	 * @author Paul
	 */
	public class ScoreHelper {
		//Score systems
		public static var Score:KillCounterWrapper;
		public static var Distance:KillCounterWrapper;
		public static var Time:KillCounterWrapper;
		
		//Zombie kill stats
		public static var AllKills:KillCounterWrapper;
		
		public static var SlowKills:KillCounterWrapper;
		public static var LimpKills:KillCounterWrapper;
		public static var RedKills:KillCounterWrapper;
		public static var BlueKills:KillCounterWrapper;
		public static var ThrowUpKills:KillCounterWrapper;
		public static var HandKills:KillCounterWrapper;
		public static var ExplosiveKills:KillCounterWrapper;
		public static var HulkKills:KillCounterWrapper;
		
		public static function Reset():void {
			Score = new KillCounterWrapper(false);
			Distance = new KillCounterWrapper(false);
			Time = new KillCounterWrapper(false);
			
			AllKills = new KillCounterWrapper();
			SlowKills = new KillCounterWrapper(true);
			LimpKills = new KillCounterWrapper(true);
			RedKills = new KillCounterWrapper(true);
			BlueKills = new KillCounterWrapper(true);
			ThrowUpKills = new KillCounterWrapper(true);
			ExplosiveKills = new KillCounterWrapper(true);
			HulkKills = new KillCounterWrapper(true);
		}
		
		
	}

}