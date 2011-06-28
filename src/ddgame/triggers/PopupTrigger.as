/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.triggers {
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.display.Stage;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.MovieClip;
	import flash.display.AVM1Movie;
	import flash.filters.GlowFilter;
	import flash.media.Sound;
	import flash.geom.Point;
	import flash.net.*
	import gs.TweenLite;
	import caurina.transitions.Equations;
	import com.sos21.debug.log;
	import com.sos21.events.BaseEvent;
	import com.sos21.helper.AbstractHelper;
	import com.sos21.tileengine.core.AbstractTile;
	import ddgame.scene.PlayerHelper;
	import ddgame.triggers.AbstractTrigger;
	import ddgame.events.EventList;
	import ddgame.proxy.LibProxy;
	import ddgame.ui.UIHelper;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class PopupTrigger extends AbstractTrigger {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 2;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _loader:Loader = new Loader();
		private var _content:MovieClip;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	@inheritDoc
		 */
		override public function execute(event:Event = null):void
		{

			// patch mailto
			if (isPropertie("mailto"))
			{
				flash.net.navigateToURL(new URLRequest("mailto:" + getPropertie("mailto")));
				complete();
				return;
			}
			// TODO kk, exturl et url, trouver soluce pour harmoniser tout ça
			// ( checker extension url pour décider de l'action à effectuer ? .swf, .png, .html... )
			if (isPropertie("exturl"))
			{
//				var targ:String = isPropertie("target") ? getPropertie("target")  : "_blank";
				
				flash.net.navigateToURL(new URLRequest(getPropertie("exturl")), isPropertie("target") ? getPropertie("target")  : "_blank");
				complete();
				return;
			}
			
			// TODO faire test sur extension url pour ouverture de lien externe (ex:pdf)
			// on test savoir si c'est un lien externe
			var surl:String = properties.arguments["url"];
			if (surl.indexOf("www") > -1)
			{
//				surl = surl.replace(/w{3}\./gi, "");
				var targ:String = isPropertie("target") ? getPropertie("target")  : "_blank";
				flash.net.navigateToURL(new URLRequest("http://" + surl), targ);
				complete();
			}
			else
			{
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
	         _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				_loader.load(new URLRequest(surl));
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	@private
		 *	Handler chargement complet
		 */
		private function loaderCompleteHandler(event:Event):void
		{
			removeLoaderListener();
			popupInit();			
		}
		
		/*
		*	Handler erreur de chargement
		*/
		private function ioErrorHandler(event:IOErrorEvent):void
		{
		   trace(event + " @" + toString());
			removeLoaderListener();
			sendEvent(new Event(EventList.UNFREEZE_SCENE));
		}
		
		/**
		 *	Handler fermeture de la popup
		 */
		private function closePopupHandler(event:Event):void
		{
			_content.getChildAt(0).removeEventListener("closePopup", closePopupHandler);
			// on supprime l'effet sur le tile
			if (sourceTarget is AbstractTile) sourceTarget.filters = [];
			stage.removeChild(_content);
			_content = null;
			_loader = null;
			complete();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	Initialisation et affichage de la popup chargée
		 */
		private function popupInit():void
		{			
			if (_loader.content is AVM1Movie) { // test version du swf;
				_content = new MovieClip();
				_content.addChild(AVM1Movie(_loader.content));
			} else {			
				_content = MovieClip(_loader.content);
				// passe la ref de ce manager à la popup swf
				_content.manager = this;
			}
			
			// patch pour annulation ouverture de la popup
			// depuis le swf loadé
			if (_content.canceled)
			{
				complete();
				return;
			}
			
			_content.addEventListener("closePopup", closePopupHandler);
			
			// -> Placement popup
			// des coordonnées sont définis dans le trigger
			if (properties.arguments["x"] != undefined && properties.arguments["y"] != undefined)
			{
				_content.x = int(properties.arguments["x"]);
				_content.y = int(properties.arguments["y"]);
			} else {
				var p:Point;		// coordonnées objet source
				var margin:Point;	// marge entre la popup et l'objet source

				// on test si le déclencheur est lié à un tile sinon on prend le perso
				// comme point coordonnée
				if (sourceTarget is AbstractTile)
				{
					var b:Object = sourceTarget.getBounds(stage);
					p = new Point(b.x, b.y);
					margin = new Point(b.width, b.height);
					// on en profite pour mettre un effet sur le tile
					sourceTarget.filters = [new GlowFilter(0x990000, 1, 10, 10)];
				} else {
					p = PlayerHelper(facade.getObserver(PlayerHelper.NAME)).stagePosition;
					margin = new Point(10, 10);
				}
				
				//	placement en x
				/*if (p.x + _content.width > (UIHelper.VIEWPORT_AREA.x + UIHelper.VIEWPORT_AREA.width))
				{
					_content.x = p.x - _content.width - 6;
				} else {
					_content.x = p.x + margin.x + 6;
				}
				// placement en y
				if (p.y + _content.height > (UIHelper.VIEWPORT_AREA.y + UIHelper.VIEWPORT_AREA.height))
				{
					_content.y = UIHelper.VIEWPORT_AREA.height - _content.height - 6;
				} else {
					_content.y = p.y;
				}*/
				_content.x = UIHelper.VIEWPORT_AREA.x;
				_content.y = UIHelper.VIEWPORT_AREA.y;				
			}
			
			stage.addChild(_content);		
			TweenLite.from(_content, 1, {tint:0xFFFFFF});
		}
		
		/**
		 *	Suppression des listeners du loader
		 */
		protected function removeLoaderListener():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
	}
	
}
