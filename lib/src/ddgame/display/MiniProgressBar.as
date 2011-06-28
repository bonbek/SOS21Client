package ddgame.display {
	
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.display.Sprite;
	import flash.display.MovieClip;

	/**
	 *	Progress bar version mini
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	[Embed(source="../../../../assets/MiniProgressBar.swf", symbol="MiniProgressBarAsset")]
	public class MiniProgressBar extends Sprite {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function MiniProgressBar ()
		{
			super();
			pBarMask.width = 0;
		}
	
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		// instance posées dans le clip
		public var title:MovieClip;
		public var pBarMask:MovieClip;
		
		// désabonnement automatique à la fin du chargement
		public var autoUnsuscribe:Boolean;
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _dipstacher:IEventDispatcher;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Retourne le IEventDispatcher écouté
		 */
		public function get dispatcher () : IEventDispatcher
		{
			return _dipstacher;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Abonnement à un IEventDispatcher (loader)
		 *	@param dispatcher IEventDispatcher
		 *	@param autoUnsuscribe Boolean
		 */
		public function suscribe (dispatcher:IEventDispatcher, autoUnsuscribe:Boolean = true) : void
		{
			_dipstacher = dispatcher;
			_dipstacher.addEventListener(ProgressEvent.PROGRESS, handleProgress, false, 0, true);

			this.autoUnsuscribe = autoUnsuscribe;

			pBarMask.width = 0;
		}
		
		/**		
		 * 
		 * Désabonnement au IEventDispatcher en cours
		 * Stop la mise à jour de l'affichage
		 */
		public function unSuscribe () : void
		{
			if (_dipstacher)
			{
				title.gotoAndStop(1);
				_dipstacher.removeEventListener(ProgressEvent.PROGRESS, handleProgress, false);
				_dipstacher = null;
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * Réception de la progression
		 *	@param e ProgressEvent
		 */
		protected function handleProgress (e:ProgressEvent) : void
		{
			if (!parent) return;
			
			if (title.currentFrame == 1) title.gotoAndPlay("loop");
			
			var bl:int = e.bytesLoaded;	
			if (bl > 0)
			{
				var bt:int = e.bytesTotal;
				// update bar de progression
				pBarMask.width = (bl / bt) * 100;
				
				if (bl >= bt && bt > 0)
				{
					if (autoUnsuscribe) {
						unSuscribe();
					} else {
						title.gotoAndStop(1);
					}
				}
			}			
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}

