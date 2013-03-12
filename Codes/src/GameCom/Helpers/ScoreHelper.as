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
			Score = new KillCounterWrapper(KillCounterWrapper.SCORE);
			Distance = new KillCounterWrapper(KillCounterWrapper.DISTANCE);
			Time = new KillCounterWrapper(KillCounterWrapper.TIME);
			
			AllKills = new KillCounterWrapper(KillCounterWrapper.TOTAL);
			
			
			SlowKills = new KillCounterWrapper(KillCounterWrapper.KILLS);
			LimpKills = new KillCounterWrapper(KillCounterWrapper.KILLS);
			RedKills = new KillCounterWrapper(KillCounterWrapper.KILLS);
			BlueKills = new KillCounterWrapper(KillCounterWrapper.KILLS);
			ThrowUpKills = new KillCounterWrapper(KillCounterWrapper.KILLS);
			ExplosiveKills = new KillCounterWrapper(KillCounterWrapper.KILLS);
			HulkKills = new KillCounterWrapper(KillCounterWrapper.KILLS);
		}
		
		
	}

}