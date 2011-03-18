package ddgame.commands {
	import flash.events.Event;
	import flash.geom.Point;
	import com.sos21.debug.log;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.tileengine.structures.UPoint;
	import ddgame.events.EventList;
	import ddgame.scene.PlayerHelper;
	import ddgame.scene.IsosceneHelper;
	import ddgame.proxy.CollisionGridProxy;

	/**
	 *	Déplace le player à un emplacement UPoint de la grille
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class MovePlayerCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute(event:Event):void
		{
			
			var cP:CollisionGridProxy = CollisionGridProxy(facade.getProxy(CollisionGridProxy.NAME));
//			var iSH:IsosceneHelper = IsosceneHelper(facade.getObserver(IsosceneHelper.NAME));
			var pH:PlayerHelper = PlayerHelper(facade.getObserver(PlayerHelper.NAME));

			/*var p:Point = BaseEvent(event).content as Point;
			var tp:Point = iSH.component.sceneLayer.findGridPoint(p);
			var up:UPoint = new UPoint(tp.x, tp.y);*/
			
			/*tp = iSH.component.sceneLayer.findFloatGridPoint(p);
			trace(tp);*/
			
			var path:Array = cP.findPath(pH.playerPosition, UPoint(BaseEvent(event).content));
//			var path:Array = cP.findPath(pH.playerPosition, up);
			
			if(path.length > 1) {
				// TODO déplacement au point cliqué précis
				/*tp = iSH.component.sceneLayer.findFloatGridPoint(p);
//				trace(path[path.length - 1].posToString());				
				path[path.length - 1].xu = tp.x - 0.5;
				path[path.length - 1].yu = tp.y - 0.5;				
//				trace(path[path.length - 1].posToString());*/
				
				pH.movePlayer(path);
			} else {
				event.preventDefault();
				sendEvent(new Event(EventList.PLAYER_MOVE_COMPLETE));
			}
		}
				
	}
	
}
