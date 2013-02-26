package LORgames.Engine.StatServers 
{
	
	/**
	 * ...
	 * @author Paul
	 */
	public class BlankStatServer implements IStatServer {
		public function StartLevel(levelID:String):void {};
		public function EndLevel():void {};
		public function Submit(statname:String, statvalue:int):void {};
	}
	
}