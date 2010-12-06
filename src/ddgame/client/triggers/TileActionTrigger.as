package ddgame.client.triggers {
	
	import flash.events.Event;
	import flash.utils.Timer;
	import com.sos21.tileengine.core.AbstractTile;
	import ddgame.client.triggers.AbstractTrigger;
	
	/**
	 *	Action d'un tile, bouger, animer, afficher / masquer...
	 * 
	 * 	act: 
    *     -
    *       a: 0 	> action : 	0 cacher
    * 								1 afficher
    * 								2 gotoFrame ?
    *       we: 1 > attendre fin
    *       t: 46 > ID tile cible
    *     -
    *        ...
    * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  30.11.2010
	 */
	public class TileActionTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 106;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var actionIndex:int = -1;
		private var actions:Array;
		private var timer:Timer;
		private var nexec:int = 0;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function execute (e:Event = null) : void
		{
			trace(this);
			if (!isPropertie("act"))
			{
				cancel();
				return;
			}
			
			actions = getPropertie("act");
			nextAction();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function nextAction (event:Event = null) : void
		{
			// check si reste des actions
			actionIndex++;
			if (actionIndex == actions.length)
			{
				var lp:int = getPropertie("lp");
				// check si on à une boucle
				if (lp > 0 && ++nexec == lp)
				{
					complete();
					return;
				}

				// on est en boucle, reset de l'index
				actionIndex = 0;
			}
			
			// prochaine action
			var act:Object = actions[actionIndex];
			
			// check si on à un tile valide
			var target:AbstractTile = AbstractTile.getTile(act.t);
			if (!target)
			{
				nextAction();
				return;
			}
			
			// option attendre fin
			var we:Boolean = act.we;
			
			// action!
			switch (int(act.a))
			{
				// > cacher tile
				case 0 :
					target.visible = false;
					break;
				// > afficher tile
				case 1 :
					target.visible = true;
					break;
			}

			if (act.d > 0)
			{
				if (!timer)
				{
					timer = new Timer(0, 0);
					timer.addEventListener("timerComplete", nextAction);
				}
				timer.delay = int(act.d * 1000);
				timer.repeatCount = 1;
				timer.start();
			}
			else
			{
				nextAction();
			}
		}
	
	}

}