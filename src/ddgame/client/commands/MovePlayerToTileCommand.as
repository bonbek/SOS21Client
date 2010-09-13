package ddgame.client.commands {
	import flash.events.Event;
	import com.sos21.debug.log;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.structures.UPoint;
	import ddgame.client.proxy.TileFactoryProxy;
	import ddgame.client.proxy.TileProxy;
	import ddgame.client.proxy.CollisionGridProxy;
	import ddgame.client.events.EventList;

	/**
	 *	Bouge le personnage jusqu'a un tile.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class MovePlayerToTileCommand extends Notifier implements ICommand {
		
		// TODO commande offline, à réparer
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute(event:Event):void
		{
			/*// on recup le tile à atteindre
			var tile:AbstractTile = AbstractTile(BaseEvent(event).content);
			var tilepos:UPoint = tile.upos;
			// on recup le proxy de collision
			var gridProxy:CollisionGridProxy = CollisionGridProxy(facade.getProxy(CollisionGridProxy.NAME));
			// on test pour savoir sur quelle céllule on va pouvoir bouger le perso
			if(!gridProxy.isCollisionCell(tilepos))
			{
				// si la céllule n'est pas une collison, le player est bougé jusqu'à celle-ci
				sendEvent(new BaseEvent(EventList.MOVE_PLAYER, tilepos));
			} else {
				// sinon on récupère on bouge le perso au point de face du tile ou au point
				// de non collision le plus proche de celui-ci
				var tpoint:UPoint;
				var tileProxy:TileProxy = TileProxy(TileFactoryProxy(facade.getProxy(TileFactoryProxy.NAME)).findTileProxy(tile));
				// on recup le point de le plus proche du tile
				tpoint = gridProxy.findNearestNoCollisionPoint(tilepos);

				// hop hop, allez on bouge
				sendEvent(new BaseEvent(EventList.MOVE_PLAYER, tpoint));
			}*/
		}
				
	}
	
}
