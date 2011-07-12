package ddgame.triggers {
	
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import com.sos21.tileengine.structures.UPoint;
	
	import ddgame.triggers.ITrigger;
	import ddgame.events.TriggerEvent;
	import ddgame.events.EventList;
	import ddgame.proxy.ProxyList;
	import ddgame.helper.HelperList;
	import ddgame.helper.HelperList;
		
	import ddgame.triggers.AbstractExternalTrigger;
	import com.sos21.observer.IObserver;

	/**
	 * Trigger Abstrait stands dynamiques(espaces entreprises)
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class dynStand extends AbstractExternalTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function dynStand ():void
		{
			super();			
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		// pnjs
		public var pnj:Object;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
				
		protected var data:XML;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
				
		/**
		 *	@inheritDoc
		 */
		override public function execute (event:Event = null):void
		{
			if (isPropertie("datafile"))
			{
				var xmldata:String = getPropertie("datafile");
				var dataPreLoader:Object = libProxy.getIGLoader(xmldata);
				if (dataPreLoader)
				{
					// les data ont été préloadées
					run(XML(dataPreLoader.loader.data));
				}
				else
				{
					// data non préloadées, on check si on est
					// sur le retour du loader
					if (event.target is URLLoader)
					{
						with (event.target)
						{
							removeEventListener(Event.COMPLETE, execute);
							removeEventListener(IOErrorEvent.IO_ERROR, execute);
							removeEventListener(SecurityErrorEvent.SECURITY_ERROR, execute);
						}
						
						if (event.type == Event.COMPLETE)
						{
							event.target.removeEventListener(Event.COMPLETE, execute, false);
							run(XML(event.target.data));
						}
						else
						{
							trace(this, " ! Erreur chargement des data");
						}
						
					}
					else
					{
						// on lance le chargement du xml data
						var dataLoader:URLLoader = new URLLoader();
						dataLoader.addEventListener(Event.COMPLETE, execute, false, 0, true);
						dataLoader.addEventListener(IOErrorEvent.IO_ERROR, execute, false, 0, true);
						dataLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, execute, false, 0, true);						
						dataLoader.load(new URLRequest(xmldata));
					}
				}
				
			} else {
				trace(this, " ! Pas de fichier source pour les data");
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	@private
		 *	Réception des evenst souris sur les pnj's
		 */
		protected function pnjMouseHandler (e:Event):void
		{
			var targ:Object = e.target;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
				{
					switch (true)
					{
						case targ == pnj.component :
						{
							pnj.jumpInLife("needHelp");
							pnj.autoLife = true;
							break;
						}
					}		
					break;
				}
			}
		}
		
		/**
		 * Réception chargement des loader d'images injectées dans
		 * les tiles. les bitmap sont smoothés si besoin
		 *	@param event Event
		 */
		protected function injectedPixLoaderComplete (event:Event):void
		{
			event.target.loader.removeEventListener(Event.COMPLETE, injectedPixLoaderComplete, false);
			
			if (event.target.loader.content is Bitmap)
				event.target.loader.content.smoothing = true;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * Injecte un media (img/swf) dans un tile grace à un conteneur
		 * Update les propriétés triggers qui sont associés au tile
		 * 
		 *	@param tileId String			identifiant du tile
		 *	@param container Object		object conteneur du media
		 *	@param injectMedia Boolean injection du media
		 */
		protected function updateTile (tileId:String, container:Object = null, injectMedia:Boolean = true):void
		{
			// tile ciblé
			var tile:Object = isosceneHelper.getTile(tileId);
			
			if (!tile) return;
			
			var nod:XML = data.inject.obj.(@id == tileId)[0];
			// url image
			var pix:String = container ? nod.image[0] : "";
			// texte toolTip
			var tooltipText:String = nod.tooltip[0];
			var ttLength:int = tooltipText.length;
			// text popup
			var popupText:String = nod.popup[0];
			var ppLength:int = popupText.length;
			
			// check si on au moins une donnée
			if (pix.length > 5 || ttLength > 2 || ppLength > 2)
			{
				if (pix.length > 5)
				{
					// on test si il y à eut préload
					var loader:Object = libProxy.getIGLoader(pix);
					if (!loader)
					{
						loader = new Loader();
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, injectedPixLoaderComplete, false, 0, true);						
						loader.load(new URLRequest(pix));
					} else {
						if (loader.content is Bitmap)
							loader.content.smoothing = true;
					}
					
					// suppression du guide
					container.removeChildAt(container.numChildren - 1);
					// injection loader et container
					container.dummy.addChild(loader);
					isosceneHelper.getTile(tileId).addChild(container);
				}
				// check si on à au moins un tooltip ou popup
				if (ttLength + ppLength > 2)
				{
					// tooltip
					if (ttLength)
					{
						replaceTriggerVal(nod.tooltip[0], "text");
					} else {
						triggerProxy.removeTrigger(nod.tooltip.attribute("id")[0]);
					}
					// popup
					if (ppLength)
					{
						// patch popup
						nod.popup[0].text()[0] += "<br><br>";
						replaceTriggerVal(nod.popup[0], "text");
					} else {
						triggerProxy.removeTrigger(nod.popup.attribute("id")[0]);
					}
				}
				else
				{
					tile.mouseEnabled = false;
					tile.buttonMode = false;
				}
			}
			else
			{
				if (injectMedia)
					isosceneHelper.component.sceneLayer.removeTile(tile);
					
				tile.mouseEnabled = false;
				tile.buttonMode = false;
			}
		}
		
		/**
		 * Remplace des valeurs "d'arguments" des triggers
		 * 
		 *	@private
		 */
		protected function replaceTriggersVal (tList:XMLList, prop:String):void
		{
			var trigger:Object;
			var newVal:String;
			for each (var nod:XML in tList)
			{
				replaceTriggerVal(nod, prop);
			}
		}
		
		/**
		 * Remplace une valeur d'argument d'un trigger
		 *	@param nod XML			noeud data sous forme <nod id="id trigger">valeur argument</nod>
		 *	@param prop String	propriété à updater
		 */
		protected function replaceTriggerVal (nod:XML, prop:String):void
		{
			var trigger:Object = triggerProxy.getTrigger(nod.@id);
			var newVal:String = nod;
			trigger.setArgument(prop, newVal);
		}
		
		/**
		 * Change le titre de la scène
		 *	@private
		 */
		protected function changeMapTitle (val:String):void
		{
			Object(facade.getObserver(ddgame.helper.HelperList.UI_HELPER)).component.sceneTitle = val;
		}
		
		/**
		 * "Vrai" lancement du trigger
		 *	@private
		 */
		protected function run (data:XML):void
		{
			this.data = data;
			
			// injections
			// > titre de la scène
			changeMapTitle(data.inject.title[0]);
			
			// mise en place pnjs
			var objBuilder:Object = facade.getProxy(ProxyList.OBJECTBUILDER_PROXY);

			var tv:Object = objBuilder.createMCTileView(new Pnj());
			var at:Object = objBuilder.createAbstractTile("pnj", 0, 0, 0, tv);
			pnj = objBuilder.createPNJHelper("pnj", at);
			facade.registerObserver(pnj.name, IObserver(pnj));
			pnj.iaData = data.pnj.(@id == "pnjAccueil")[0];
			pnj.autoLife = true;
			
			// ecoute events souris sur pnjs
			pnj.component.addEventListener(MouseEvent.MOUSE_OVER, pnjMouseHandler, false, 0, true);
			
			// ajout listener sur changement de map
			channel.addEventListener(EventList.CLEAR_MAP, complete, false, 50);
		}
		
		/**
		 * Retourne proxy lib
		 * @private
		 */
		protected function get libProxy ():Object
		{
			return facade.getProxy(ProxyList.LIB_PROXY);
		}
		
		/**
		 * Retourne le proxy triggers
		 * @private
		 */
		protected function get triggerProxy ():Object
		{
			return facade.getProxy(ProxyList.TRIGGERS_PROXY);
		}
		
		/**
		 * Retourne helper isoscene
		 * @private
		 */
		/*protected function get isosceneHelper ():Object
		{
			return facade.getObserver(ddgame.helper.HelperList.ISOSCENE_HELPER);
		}*/
		
		/**
		 *	@inheritDoc
		 */
		override protected function complete(event:Event = null):void
		{
			channel.removeEventListener(EventList.CLEAR_MAP, complete, false);
			pnj.component.removeEventListener(MouseEvent.MOUSE_OVER, pnjMouseHandler, false);
			super.complete();
		}
		
	}

}