package ddgame.client.triggers {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.StyleSheet;
	import flash.events.TextEvent;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;

	import flash.net.URLRequest;
	
	import com.sos21.events.BaseEvent;
	import com.sos21.events.ApplicationChannel;
	import com.sos21.proxy.ConfigProxy;
	import ddgame.client.view.PlayerHelper;
	
	import com.sos21.tileengine.core.AbstractTile;
	import ddgame.client.triggers.AbstractTrigger;
	import ddgame.client.proxy.LibProxy;
	import ddgame.client.proxy.TileTriggersProxy;
	import ddgame.client.triggers.TriggerProperties;
	import ddgame.view.UIHelper;
	import ddgame.client.events.EventList;
	import ddgame.server.events.PublicServerEventList;
	
	import gs.TweenLite;
	import gs.easing.*;
	
	/**
	 *	Trigger popup html
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class HtmlPopupTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 9;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		/**
		 *	@private
		 *	assets de la popup
		 */
		private var _component:MovieClip;
		
		/**
		 *	@private
		 *	editeur html (temporaire)
		 */
		private var _editor:Object;
		private var _editButton:SimpleButton;
		private var _unEditButton:SimpleButton;
		private var _saveButton:SimpleButton;
		private var _saveMessage:Sprite;
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		public var htmlStyleSheet:StyleSheet;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		override public function get classID():int {
			return CLASS_ID;
		}
		
		public function get textField() : TextField
		{
//			trace(_component.htmlContent);
			return _component ? _component.htmlContent : null;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function execute (event:Event = null) : void
		{
			if (isPropertie("text"))
			{
				if (getPropertie("text").length > 1)
				{
					_build();
					return;
				}					
			}

			// on veut un contenu de la DB
			if (isPropertie("id"))
			{
				ApplicationChannel.getInstance().addEventListener(PublicServerEventList.ON_DATACONTENT, dataContentHandler);
				sendPublicEvent(new BaseEvent(PublicServerEventList.GET_DATACONTENT, getPropertie("id")));
				sendEvent(new Event(EventList.FREEZE_SCENE));
//				sendEvent(new BaseEvent(EventList.DISPLAY_HOURGLASS, true));
				return;
			}
			
			complete();
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
				
		/**
		 *	Réception des data (contenu texte / html) depuis
		 *	le remoting
		 *	recupération du contenu et lancement de l'affichage
		 */
		protected function dataContentHandler(event:BaseEvent):void
		{
			ApplicationChannel.getInstance().removeEventListener(PublicServerEventList.ON_DATACONTENT, dataContentHandler);
			setPropertie("text", event.content.body);
//			sendEvent(new BaseEvent(EventList.DISPLAY_HOURGLASS, false));
			sendEvent(new Event(EventList.UNFREEZE_SCENE));
			_build();
		}
		
		/**
		 *	@private
		 *	Recption events clavier pour empêcher fonction debug
		 */
		protected function keyDownHandler(e:Event):void
		{
			e.stopImmediatePropagation();
		}
		
		/**
		 *	@private
		 *	reception events souris sur stage
		 */		
		protected function stageMouseHandler(event:MouseEvent):void
		{
//			if (!_component.getBounds(stage).contains(stage.mouseX, stage.mouseY) && event.target is AbstractTile) {
			if (event.target is AbstractTile) {
				complete();
			}
		}
		
		/**
		 *	@private
		 *	Reception des events liens cliqués dans la popup
		 *	
		 *	encodage des lien pour déclencher des triggers :	
		 *		lien vers autre trigger :
		 *		ex event:trigger:id		id identifiant du trigger à exec
		 * 	les liens ver url http, mailto, relatifs peuvent être passés
		 * 	event:trigger:10#http://toto.com
		 *		options :
		 *		autoClose	ferme la popup après avoir lancé le/les triggers
		 *		ex :
		 * 		lien vers trigger 			event:trigger:10#autoClose
		 * 		lien externe					event:http://www.toto.com#autoClose
		 * 		lien trigger + externe		event:trigger:10#http://www.toto.com#autoClose
		 * 		lien relatif 					event:rel:contents/mondocs.pdf
		 */
		protected function componentLinkHandler(event:TextEvent):void
		{
			var tproxy:TileTriggersProxy = facade.getProxy(TileTriggersProxy.NAME) as TileTriggersProxy;
			var tlist:Array = event.text.split("#");
			var ids:Array;
			var args:Array;
			var trProp:TriggerProperties;
			var n:int = tlist.length;
			var autoClose:Boolean = false; // <A HREF="event:trigger:103#autoClose:true"
			for (var i:int = 0; i < n; i++)
			{
				ids = tlist[i].split(":");
				switch (ids[0])
				{
					case "trigger" :
						tproxy.launchTriggerByID(ids[1]);
						break;
					case "rel" :
						flash.net.navigateToURL(new URLRequest(ids[1]), "_blank");
						break;
					case "ftp" :
					case "http" :
					case "https" :
					case "mailto" :
						flash.net.navigateToURL(new URLRequest(tlist[i]), "_blank");
						break;
					case "autoClose" :
						autoClose = true;
						break;
				}
			}
			// on ferme la popup
			if (autoClose) complete();
		}		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@private
		 *	Mets en place la popup et l'effet d'apparition
		 */
		protected function _build():void
		{
//			PlayerHelper(facade.getObserver(PlayerHelper.NAME)).displayTalk(getPropertie("text"));
//			return;
			
			// on recup l'asset
			var libProxy:LibProxy = LibProxy(facade.getProxy(LibProxy.NAME));
			var classRef:Class = libProxy.lib.getClassFrom(libProxy.libPath + "HtmlPopup.swf", isPropertie("skin") ? getPropertie("skin") : "DefaultPopup");
			_component = new classRef;
			_component.manager = this;
			
			_component.addEventListener("closePopup", complete, false, 0, true);
						
			// ajout d'un ombré
			var filt:DropShadowFilter = new DropShadowFilter(4);
			filt.alpha = 0.5;
			_component.filters = [filt];
			
			// styleSheet de la popup
			htmlStyleSheet = new StyleSheet();
			
			var link:Object = new Object();
			/*link.fontFamily = "Arial";*/
			link.fontSize = "13";
			link.textDecoration= "none";
			/*link.fontStyle = "italic";*/
			link.color = "#EC02BD";
			
			var hover:Object = new Object();
			hover.textDecoration= "underline";
						
/*			var active:Object = new Object();
			active.fontWeight = "bold";
			active.color = "#FF0000";

			var visited:Object = new Object();
			visited.fontWeight = "bold";
			visited.color = "#cc0099";
			visited.textDecoration= "underline";*/
			
			htmlStyleSheet.setStyle("a:link", link);
			htmlStyleSheet.setStyle("a:hover", hover);

			/*style.setStyle("a:active", active);
			style.setStyle(".visited", visited);*/
			
			_component.htmlContent.styleSheet = htmlStyleSheet;
			
			// placement et taille
			stage.addChild(_component);
			_component.x = isPropertie("x") ? int(getPropertie("x")) : ((UIHelper.VIEWPORT_AREA.width - _component.width) / 2) + UIHelper.VIEWPORT_AREA.x;
			_component.y = isPropertie("y") ? int(getPropertie("y")) : UIHelper.VIEWPORT_AREA.y + 20;
			if (isPropertie("width")) _component.width = int(getPropertie("width"));
			if (isPropertie("height")) _component.maxHeight = int(getPropertie("height"));

			// on passe le texte
			_component.text = getPropertie("text");
	
			// fx d'aparition
			TweenLite.from(_component, 0.5, {tint:0xffffff});
			
			// on mets un effet à la source
			if (sourceTarget is AbstractTile)
			{
				sourceTarget.mouseEnabled = false;
				sourceTarget.filters = [new GlowFilter(0x990000, 1, 10, 10)];
			}
			
			// ajout listener pour fermer la popup si user click dans la scène
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseHandler, false, 0, true);
			// ajout listener sur les liens cliqués dans la popup
			_component.htmlContent.addEventListener(TextEvent.LINK, componentLinkHandler, false, 0, true);
			// PATCH pour éviter les fonctions debuggage (GridHelper)
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 100, true);
		}
		
		/**
		 *	@inheritDoc
		 */
		override protected function complete(event:Event = null):void
		{
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseHandler, false);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false);
			if (sourceTarget is AbstractTile)
			{
				sourceTarget.filters = [];
				sourceTarget.mouseEnabled = true;
			}
			if (_component)
			{
				_component.removeEventListener("closePopup", complete, false);
				TweenLite.to(_component, 0.1, {tint:0xffffff, onComplete:stage.removeChild, onCompleteParams:[_component]})
			}
			
			super.complete();
		}
			
	}

}

