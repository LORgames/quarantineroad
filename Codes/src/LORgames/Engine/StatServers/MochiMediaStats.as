package LORgames.Engine.StatServers 
{
	import mochi.as3.MochiEvents;
	import mochi.as3.MochiServices;
	/**
	 * ...
	 * @author Paul
	 */
	public class MochiMediaStats implements IStatServer {
		
		private var isWorking:Boolean = true;
		
		public function MochiMediaStats() {
			MochiServices.connect("5a3aaf31eb62a90e", Main.GetStage(), onConnectError);
		}
		
		private function onConnectError(str:String):void {
			//trace("mochi stats error: " + str);
			//isWorking = false;
		}
		
		public function StartLevel():void {
			MochiEvents.startPlay();
		}
		
		public function EndLevel():void {
			MochiEvents.endPlay();
		}
		
		public function Submit(statname:String, statvalue:int):void {
			//TODO: Redirect this API elsewhere?
			//if(isWorking) {
			//	MochiEvents.trackEvent(statname, statvalue);
			//}
		}
		
	}

}