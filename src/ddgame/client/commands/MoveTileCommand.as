package ddgame.client.commands {
	import flash.events.Event;
	import com.sos21.debug.log;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.structures.UPoint;
	import ddgame.client.proxy.CollisionGridProxy;

	/**
	 *	Déplace un tile à un emplacement UPoint de la grille
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class MoveTileCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute(event:Event):void
		{
			var o:Object = BaseEvent(event).content;
			var tile:AbstractTile = AbstractTile(o.tile);
			var cP:CollisionGridProxy = CollisionGridProxy(facade.getProxy(CollisionGridProxy.NAME));
			var path:Array = cP.findPath(tile.upos, UPoint(o.cellTarget));
			if(path.length > 1)
				tile.pathTo(path);
		}
				
	}
	
}
