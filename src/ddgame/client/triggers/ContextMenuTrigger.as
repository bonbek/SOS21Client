package ddgame.client.triggers {
	
	import flash.events.Event;	
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import gs.TweenLite;
	import com.sos21.debug.log;
	import com.sos21.helper.AbstractHelper;
	import com.sos21.events.BaseEvent;
	import ddgame.client.triggers.AbstractTrigger;
	import ddgame.client.view.components.ContextMenu;
	import ddgame.client.view.components.ContextMenuItem;
	import ddgame.client.events.EventList;
	import ddgame.client.events.TriggerEvent;
	import ddgame.client.proxy.TileTriggersProxy;
	
	/**
	 *	Trigger menu contextuel
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class ContextMenuTrigger extends AbstractTrigger {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------

		public static const CLASS_ID:int = 4;

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function ContextMenuTrigger()
		{}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var triggerIdList:Array;		// Liste des trigger id
		private var labelList:Array;			// Liste des labels affichés dans le menu
		private var contextMenuSprite:ContextMenu;
		
		// patch recup item selectioné au click
		public var selectedEntry:ContextMenuItem;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		override public function get classID():int {
			return CLASS_ID;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		override public function execute (event:Event = null) : void
		{
//			sendEvent(new Event(EventList.FREEZE_SCENE));
			triggerIdList = String(properties.arguments["tl"]).split("#");
			labelList = String(properties.arguments["ll"]).split("#");
			var l:int = triggerIdList.length;
			if (l == labelList.length && l > 0)
				createContextMenu();
			else
				cancel();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function menuItemHandler(event:MouseEvent):void
		{
			// TODO enlever tous les listeners ou passer par Signal dans ContextMenu (yes)
			selectedEntry = ContextMenuItem(event.target);
			var lab:String = selectedEntry.label;
			var triggerId:int = triggerIdList[labelList.indexOf(lab)];
			sendEvent(new BaseEvent(EventList.LAUNCH_TRIGGER, {id:triggerId, source:this}));
			contextMenuSprite.remove();
			complete();
		}
		
		private function onClose (e:Event) : void
		{
			contextMenuSprite.removeEventListener(Event.CLOSE, onClose);
			cancel();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function createContextMenu():void
		{
			contextMenuSprite = new ContextMenu(AbstractHelper.stage);
			contextMenuSprite.addEventListener(Event.CLOSE, onClose, false, 0, true);
			
			// --> Patch pour insérer intitulé
			if (isPropertie("title"))
			{
				var tit:ContextMenuItem = new ContextMenuItem(getPropertie("title"), new TextFormat("Verdana", 12, 0xDFB9C9));
				tit.mouseEnabled = false;
				tit.height+= 10;
				contextMenuSprite.pushMenuItem(tit);
			}			
			// <--
			
			// CHANGED 2010-07-17 suppression des entrées qui ne sont plus des triggers valides
			// pour éviter que les entrées qui ne déclenche rien ne s'affichent pas
			
			var tproxy:TileTriggersProxy = TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME));
			
			// "disable verify"
			var dvf:Boolean = getPropertie("dvf");
			var l:int = labelList.length;	
			for (var i:int = 0; i < l; i++)
			{
				if (!dvf)
					if (!tproxy.isValidTrigger(triggerIdList[i])) continue;
				
				var label:String = labelList[i];
				var cmi:ContextMenuItem = new ContextMenuItem(label);
				cmi.addEventListener(MouseEvent.CLICK, menuItemHandler);
				contextMenuSprite.pushMenuItem(cmi);
			}
			
			TweenLite.from(contextMenuSprite, 0.4, {tint:0xFFFFFF});
		}
		
	}
	
}
