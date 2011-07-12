package ddgame.ui {

	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.media.SoundMixer; 
	import flash.net.URLRequest;	

	import com.sos21.events.BaseEvent;
	import com.sos21.helper.AbstractHelper;

	import ddgame.helper.HelperList;
	import ddgame.ui.UIHelper;
	import ddgame.events.EventList;
	
//	import firstconnexion.events.EventList;

	/**
	 *	Helper du module prémière connexion d'un utilisateur
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class FirstConnexionHelper extends AbstractHelper {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME : String = "firstConnexionHelper";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function FirstConnexionHelper (sname:String = null)
		{
			super(sname == null ? NAME : sname);
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
	
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Retourne le composant transtypé
		 */
		public function get component ():MovieClip
		{
			return _component ? MovieClip(_component.content) : null;
		}		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	Lance le chargement du module
		 */
		public function load ():void
		{
			// recup zone affichable dans ui
			var bds:Object = UIHelper.VIEWPORT_AREA;
			
			_component = new Loader();
			_component.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderHandler, false, 0, true);
			_component.load(new URLRequest("firstConnexion.swf"));
			_component.x = bds.x;
			_component.y = bds.y;
			
			stage.addChild(_component as Loader);
			
			// on définit un titre
			UIHelper(facade.getObserver(HelperList.UI_HELPER)).component.sceneTitle =  "Bienvenue dans sos-21";
		}
		
		/**
		 *	Relache la vue
		 */
		public function release ():void
		{
			if (component) {
				component.removeEventListener(EventList.USER_UPDATED, componentHandler, false);
			}
			
			if (_component) {
				SoundMixer.stopAll();
				_component.unload();
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * Réception events du composant
		 *	@param e Event
		 */
		private function componentHandler (e:Event):void
		{
			switch (e.type)
			{
				case EventList.USER_UPDATED : // joueur à choisi son pseudo, avatar et home
					component.mouseEnabled = false;
					component.mouseChildren = false;
					trace("component updated");
					sendEvent(new BaseEvent(EventList.REFRESH_USER));
					break;
			}
		}
		
		/**
		 * Réception chargement du composant
		 *	@param e Event
		 */
		private function loaderHandler (e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, loaderHandler, false);
			
			// init du composant
			component.facade = this.facade;
			component.addEventListener(EventList.USER_UPDATED, componentHandler, false, 0, true);
			
			// démarage du composant
			component.nextFrame();
		}
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}

