package ddgame.triggers {
	
	import flash.events.Event;
	import com.sos21.debug.log;
	import ddgame.triggers.AbstractTrigger;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.events.TileEvent;
	import com.sos21.events.BaseEvent;
	import ddgame.events.EventList;

	/**
	 *	Lance le déplacement d'un tile
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class MoveTileTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 6;		// identifiant de la classe du trigger
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
	
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		override public function get classID():int {
			return CLASS_ID;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		override public function execute(event:Event = null):void
		{
			if (isPropertie("target") && isPropertie("tile")) {

				// patch pour déplacement perso
				var tileTa:String = getPropertie("tile");
				if (tileTa == "1000") tileTa = "bob";

				// le tile à bouger
				var tileTm:AbstractTile = AbstractTile.getTile(tileTa);

				tileTm.addEventListener(TileEvent.MOVE_COMPLETE, moveCompleteHandler);
					
				var tar:Array = getPropertie("target").split("/");
				// on test savoir si le target est un tile ou une céllule
				if (tar.length == 3)
				{
					// target est une céllule
					var tpoint:UPoint = new UPoint(tar[0], tar[1], tar[2]);
					// on test savoir si le tile est déjà à cette place
					if (!tileTm.upos.isMatchPos(tpoint))
					{
						sendEvent(new BaseEvent(EventList.MOVE_TILE, {tile:tileTm, cellTarget:tpoint}));
					} else {
						tileTm.removeEventListener(TileEvent.MOVE_COMPLETE, moveCompleteHandler);
						complete();
						return;
					}
																					
				}
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function moveCompleteHandler(event:Event = null):void
		{
			event.target.removeEventListener(TileEvent.MOVE_COMPLETE, moveCompleteHandler);
			complete();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}

