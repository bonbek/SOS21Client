package ddgame.client.triggers {
	
	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.helper.AbstractHelper;
	import ddgame.client.triggers.AbstractTrigger;
	import ddgame.client.events.EventList;
	import ddgame.server.events.PublicServerEventList;
	
	/**
	 *	Trigger chagement de scène
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class ChangeMapTrigger extends AbstractTrigger {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 1;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		// data destination choisie
		protected var destination:Object;
		protected var transport:Object;
		// popup selection
		protected var pop:Pop;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function execute (event:Event = null) : void
		{
         /*dest: 
             - 
                 title: Arles hall FIIE
                 map: 56
                 trans: |
                     1|en train|test#2|en vélo	*/
			
			// V2 choix destination et transport
			/*var dests:Array = getPropertie("dest");
			if (dests)
			{
				var destCount:int = dests.length;
				if (destCount > 1)
				{
					// plusieurs destinations, affichage choix destination
					chooseDestination(dests);
				}
				else
				{
					// une seule destination, affichage choix des modes de transports
					destination = dests[0];
					chooseTransport(destination);
				}
			}*/
			
			// V2
			if (isPropertie("dest"))
			{
				chooseDestination();
				return;
			}
			else
			{
				// compatibilté V1
				if (isPropertie("mapid"))
				{
					destination = {mapId:getPropertie("mapid"), entryPoint:getPropertie("entryPoint"),
										removeTriggers:getPropertie("removeTriggers")};

					goToMap();
				}
			}

			// compatibilté V1
			complete();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * Réception clique dans popup choix destination
		 *	@param item Object
		 */
		private function popDestinationClicked (item:Object) : void
		{
			stage.removeChild(pop);
			destination = item.data;
			destinationChoosed();
		}
		
		/**
		 * Réception clique dans popup choix transport
		 *	@param item Object
		 */
		private function popTransportClicked (item:Object) : void
		{
			stage.removeChild(pop);
			transport = item.data;
			transportChoosed();
		}
		
		/**
		 *	Réception nouvelle scène affichée
		 */
		private function onMapChanged (event:Event = null) : void
		{
			channel.removeEventListener(EventList.ISOSCENE_BUILDED, onMapChanged, false);
			trace("onMapChanged");
			properties.persist = false;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * Affichage choix destination
		 *	@param dests Array
		 */
		protected function chooseDestination () : void
		{
			trace(this, "chooseDestination")
			
			var dests:Array = getPropertie("dest");
			if (dests)
			{
				var destCount:int = dests.length;
				if (destCount > 1)
				{
					// plusieurs destinations, affichage choix destination
					pop = new Pop();
					for each (var d:Object in dests)
						pop.createEntry(d.title, d);

					pop.entrySelected.addOnce(popDestinationClicked);
					stage.addChild(pop);
				}
				else
				{
					// une seule destination, affichage choix des modes de transports
					destination = dests[0];
					chooseTransport();
				}
			}
			else
			{
				// aucune destination
				complete();
			}
		}
		
		/**
		 * Affichage choix transports
		 *	@param dest Object
		 */
		protected function chooseTransport () : void
		{
			trace(this, "chooseTransport");

			if (!("trans" in destination))
			{
				trace(this, "à pied");
				transportChoosed();
				return;
			}
			else
			{
//				var trans:Array = destination.trans.split("#");
				var trans:Array = destination.trans;
				if (trans.length == 1)
				{
					// un seul moyen de transport
					transport = trans[0];
					transportChoosed();
				}
				else
				{
					// plusieurs moyen de transport
					pop = new Pop();
//					var dt:Array;
//					for each (var t:String in trans)
					for each (var dt:Object in trans)
					{
//						dt = t.split("|");
//						pop.createEntry(dt[1], dt);
						pop.createEntry(dt.title, dt)
					}
				
					pop.entrySelected.addOnce(popTransportClicked);
					stage.addChild(pop);
				}
			}
		}
		
		/**
		 *	@private
		 */
		private function destinationChoosed () : void
		{
			trace(this, "destinationChoosed", destination);
			chooseTransport();
		}
		
		/**
		 *	@private
		 */
		private function transportChoosed () : void
		{
			trace(this, "transportChoosed", transport);
			goToMap();
		}
		
		/**
		 *	@private
		 */
		protected function goToMap () : void
		{
			if (transport)
			{
				trace(this, "goToMap");
				properties.persist = true;
				channel.addEventListener(EventList.ISOSCENE_BUILDED, onMapChanged, false);
			}

			sendEvent(new BaseEvent(EventList.GOTO_MAP, destination));
		}
		
	}
	
}

// POUR TESTS
import flash.events.*
import flash.text.*;
import org.osflash.signals.*;

internal class Pop extends MiniGameBox
{

		public function Pop ()
		{
			super(300);
			addEventListener(MouseEvent.CLICK, handleClick);
		}
		
		public var entrySelected:Signal = new Signal();
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		public function createEntry (label:String, data:Object) : void
		{
			addChild(new PopItem(label, data));
		}
		
		public function addItem (item:PopItem) : void
		{
			addChild(item);
		}

		public function removeItem (item:PopItem) : void
		{
		}

		//---------------------------------------
		// PRIVATE & PROTECTED METHODS
		//---------------------------------------

		protected function handleClick (e:MouseEvent) : void
		{
			var t:Object = e.target;
			if (t is PopItem) entrySelected.dispatch(t);
			//else
			//	if (e.target == vbtn) validatList.dispatch();
		}

		override protected function drawChildren () : void
		{
			// check des styles
			setStyle("direction", "vertical");
			setStyle("paddingLeft", 20);
			setStyle("paddingTop", 20);
			setStyle("paddingRight", 20);
			setStyle("verticalGap", 4);

			super.drawChildren();
		}
		
		override public function validate (e:Event = null) : Boolean
		{
			graphics.beginFill(0xFF0000);
			graphics.drawRect(0, 0, width, width);

			return super.validate();
		}

}

internal class PopItem extends MiniGameButton {
	
	public static var styles:Object = {fontFamily:"Verdana"};
	
	//---------------------------------------
	// CONSTRUCTOR
	//---------------------------------------
	
	public function PopItem (label:String, data:Object)
	{
		super(0, 0, styles);
//		_label = label;
		percentWidth = 100;
		this.data = data;
		this.label = label;
	} 
	
	//---------------------------------------
	// PRIVATE & PROTECTED INSTANCE VARIABLES
	//---------------------------------------
	
	public var data:Object;
	/*protected var _label:String;
	protected var tf:TextField;*/
	
	//---------------------------------------
	// PRIVATE & PROTECTED METHODS
	//---------------------------------------
	
	/*override protected function drawChildren () : void
	{
		width = 130;
		setStyle("horizontalGap", 3);
		
		tf = new TextField();
		tf.multiline = tf.wordWrap = tf.selectable = false;
		tf.embedFonts = true;
		tf.width = 150;
		tf.height = 18;
//		tf.autoSize = "left";
		
		var f:TextFormat = new TextFormat("Verdana", 16, 0xFFFFFF);
		f.align = "center";
		tf.defaultTextFormat = f;
		addChild(tf);

		super.drawChildren();		
	}
	
	override public function validate (e:Event = null) : Boolean
	{
//		if (!super.validate(e)) return false;
		tf.width = width;
		tf.text = _label;
		
		return super.validate(e);
	}*/
	
}