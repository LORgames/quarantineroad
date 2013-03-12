package GameCom.GameComponents {
	/**
	 * ...
	 * @author Paul
	 */
	public interface IHit {
		/**
		 * 
		 * @param	damage
		 * @return false if alive, true if dead
		 */
		function Hit(damage:Number):Boolean;
	}
	
}