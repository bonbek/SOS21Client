package ddgame.triggers {
	
	import flash.events.Event;
	import gs.TweenMax;
	import gs.easing.*;
	import com.sos21.events.BaseEvent;
	import com.sos21.helper.AbstractHelper;
	import ddgame.triggers.AbstractTrigger;
	import ddgame.events.EventList;
	import ddgame.events.ServerEventList;
	import ddgame.proxy.DatamapProxy;
	import ddgame.scene.PlayerHelper;
	import ddgame.ui.UIHelper;
	import ddgame.proxy.PlayerProxy;
	
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
		
		// data destination / transport choisi(s)
		protected var destination:Object;
		protected var transport:Object;
		// latittutde / longitude map en cours
		protected var lastLocation:Object;
		// popup selection
		protected var popup:Object;
		//
		protected var state:String;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		protected function get datamapProxy () : DatamapProxy
		{ return DatamapProxy(facade.getProxy(DatamapProxy.NAME)); }
		
		protected function get playerHelper () : PlayerHelper
		{ return PlayerHelper(facade.getProxy(PlayerHelper.NAME)); }
		
		protected function get uiHelper () : UIHelper
		{ return UIHelper(facade.getObserver(UIHelper.NAME)); }
		
		protected function get playerProxy () : PlayerProxy
		{ return PlayerProxy(facade.getProxy(PlayerProxy.NAME)); }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function execute (event:Event = null) : void
		{
			// V2
			if (isPropertie("dest"))
			{
				// on freeze la scène
				sendEvent(new BaseEvent(EventList.FREEZE_SCENE));
				chooseDestination();
			}
			else
			{
				// compatibilté V1
				if (isPropertie("mapid"))
				{
					sendEvent(new BaseEvent(EventList.GOTO_MAP, { 	mapId:getPropertie("mapid"),
					 																entryPoint:getPropertie("entryPoint"),
																					removeTriggers:getPropertie("removeTriggers")}));
					super.complete();
				}
			}
		}
		
		/**
		 *	@param 1 Number
		 *	@param 1 Number
		 *	@param 2 Number
		 *	@param 2 Number
		 *	@param  Boolean
		 *	@return Number
		 */
		public function getLatLngDistance ($lat1:Number, $lng1:Number, $lat2:Number, $lng2:Number, $miles:Boolean = false) : Number
		{
			var pi80:Number = Math.PI/180;
			$lat1 *= pi80;
			$lng1 *= pi80;
			$lat2 *= pi80;
			$lng2 *= pi80;

			var earthRadius:Number = 6372.797; // mean radius of Earth in km
			var dlat:Number = $lat2-$lat1;
			var dlng:Number = $lng2-$lng1;
			var a:Number = Math.sin(dlat / 2) * Math.sin(dlat / 2) + Math.cos($lat1) * Math.cos($lat2) * Math.sin(dlng / 2) * Math.sin(dlng / 2);
			var c:Number = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
			var km:Number = earthRadius*c;

			return ($miles ? (km * 0.621371192) : km);
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
			uiHelper.removeWindow(popup);
			destination = item.data;
			destinationChoosed();
		}
		
		/**
		 * Réception clique dans popup choix transport
		 *	@param item Object
		 */
		private function popTransportClicked (item:Object) : void
		{
			// check si joueur à assez de points
			var playerEco:int = playerProxy.getBonus(3).gain;
			if (playerEco - item.data.ecost < 0)
			{
				
			}
			else
			{
				uiHelper.removeWindow(popup);
				transport = item.data;
				transportChoosed();				
			}
		}
		
		/**
		 *	Réception nouvelle scène affichée
		 */
		private function onMapChanged (event:Event = null) : void
		{
			channel.removeEventListener(EventList.SCENE_BUILDED, onMapChanged, false);
			
			if (transport)
			{
				var currentLocation:Object = datamapProxy.location;
				// distance kilomètres entre les deux scènes
				var distance:int = getLatLngDistance(currentLocation.lat, currentLocation.lon, lastLocation.lat, lastLocation.lon);
				// coût CO2 en grammes
				var co2cost:Number = distance * transport.co2cost;
				co2cost = int((co2cost) * 100) / 100;
//				trace("distance:", distance, "coût co2:", co2cost);
				// coût éco
//				trace("coût éco", transport.ecost);
				
				// displatch points
				// > piraniak
				/*sendEvent(new BaseEvent(EventList.ADD_BONUS, {theme:1, bonus:transport.pcost}));*/
				// > éco
				if (transport.ecost)
					sendEvent(new BaseEvent(EventList.ADD_BONUS, {theme:3, bonus:-transport.ecost}));
				// > social
				if (transport.scost)
					sendEvent(new BaseEvent(EventList.ADD_BONUS, {theme:2, bonus:transport.scost}));
				// > environnement
				if (transport.encost)
					sendEvent(new BaseEvent(EventList.ADD_BONUS, {theme:4, bonus:transport.encost}));
				
				// affichage pop info
				if ("info" in transport)
				{
					state = "info";
					
					popup = uiHelper.createWindow(false);
					var tit:String = 'Ton trajet de <font size="13">' + lastLocation.title + '\nà ' + destination.title + '</font> ' + transport.title;
					popup.title = tit;
					var infoTxt:String = String(transport.info).replace(/#co2#/g, co2cost / 1000);
					infoTxt = infoTxt.replace(/#dist#/g, distance);
					popup.addChild(new InfoText(infoTxt, tit.length * 4.5));
					popup.closeButton = true;
					popup.onClose.addOnce(onPopupClosed);

					uiHelper.addWindow(popup);

					return;
				}
			}
			
			complete();
		}
		
		/**
		 * Réception fermeture popup
		 *	@param event Event
		 */
		private function onPopupClosed (event:Event) : void
		{
			if (state == "info")
			{
				complete();
			}
			else
			{
				cancel();
			}
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
			var dests:Array = getPropertie("dest");
			if (dests)
			{
				var destCount:int = dests.length;
				if (destCount > 1)
				{
					// plusieurs destinations, affichage choix destination
					popup = uiHelper.createWindow(false);
					popup.title = "Se rendre à";
					popup.closeButton = true;
					popup.onClose.addOnce(onPopupClosed);
					var list:ButtonList = new ButtonList();
					for each (var d:Object in dests)
						list.addButton(new DButton(d.title, d));
					
					list.entrySelected.addOnce(popDestinationClicked);

					popup.addChild(new MiniGameUIContainer(0, 12));
					popup.addChild(list);
					if (popup.width < 250) popup.width = 250
					uiHelper.addWindow(popup);
				}
				else
				{
					// une seule destination, affichage choix des modes de transports
					destination = dests[0];
					destinationChoosed();
//					chooseTransport();
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
			if (!("trans" in destination))
			{
				transportChoosed();
				return;
			}
			else
			{
				var trans:Array = destination.trans;
				if (trans.length == 1)
				{
					// un seul moyen de transport
					transport = trans[0];
					transportChoosed();
				}
				else
				{
					// plusieurs moyens de transports
					var playerEco:int = playerProxy.getBonus(3).gain;
					popup = uiHelper.createWindow(false);
					popup.closeButton = true;
					popup.onClose.addOnce(onPopupClosed);
					popup.title = 'Se rendre à\n<font size="13">' + destination.title + '</font>';				
					var list:ButtonList = new ButtonList();
					var btn:TButton;
					for each (var dt:Object in trans)
					{
						// check si points eco suffisants
						if (playerEco - dt.ecost < 0)
						{
							btn = new TButton(dt.title, dt, 0xFF0000, "tu n'as pas assez de points éco !");
///							btn.enabled = false;
							list.addButton(btn);
						}
						else
						{
							list.addButton(new TButton(dt.title, dt));
						}
						
					}
						
					list.entrySelected.addOnce(popTransportClicked);

					popup.addChild(new CostLabel());
					popup.addChild(list);
					
					uiHelper.addWindow(popup);
				}
			}
		}
		
		/**
		 *	@private
		 */
		private function destinationChoosed () : void
		{
			chooseTransport();
		}
		
		/**
		 *	@private
		 */
		private function transportChoosed () : void
		{
			// check si joueur à assez de points
			var playerEco:int = playerProxy.getBonus(3).gain;
			if (transport)
			{
//				5 - 20 = -15;
				var diff:int = playerEco - transport.ecost;
				if (diff < 0)
				{
					popup = uiHelper.createWindow(false);
//					var tit:String = 'Tu ne peux te rendre à \n<font size="13">' + destination.title + '</font>\n';
					var tit:String = "Domage !\n\n"
					popup.title = tit;
					var infoTxt:String = "<FONT size=\"16\">Tu ne peux te rendre à " + destination.title + ", il te manque <FONT color=\"#F7BC00\"><b>" + Math.abs(diff) + " points éco.</b></FONT></FONT>";
					popup.addChild(new InfoText(infoTxt, 340));
					popup.closeButton = true;
					popup.onClose.addOnce(onPopupClosed);
					uiHelper.addWindow(popup);
					return;
				}				
			}

			goToMap();
		}
		
		/**
		 *	@private
		 */
		protected function goToMap () : void
		{
			if (transport)
			{				
				properties.persist = true;

				// stockage latitude / longitude pour calcule kilomètres
				lastLocation = {title:datamapProxy.title,
									lat:datamapProxy.location.lat,
									lon:datamapProxy.location.lon};

				channel.addEventListener(EventList.SCENE_BUILDED, onMapChanged, false);
				sendEvent(new BaseEvent(EventList.GOTO_MAP, destination));
			}
			else
			{
				sendEvent(new BaseEvent(EventList.GOTO_MAP, destination));
				complete();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cancel () : void
		{
			properties.persist = false;
			popup = null;
			lastLocation = null;
			destination = null;
			transport = null;
			channel.removeEventListener(EventList.SCENE_BUILDED, onMapChanged, false);
			sendEvent(new BaseEvent(EventList.UNFREEZE_SCENE));

			super.cancel();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function complete (event:Event = null) : void
		{
			properties.persist = false;
			popup = null;
			lastLocation = null;
			destination = null;
			transport = null;
			channel.removeEventListener(EventList.SCENE_BUILDED, onMapChanged, false);
			sendEvent(new BaseEvent(EventList.UNFREEZE_SCENE));

			super.complete();
		}
		
	}
	
}


import flash.events.*
import flash.text.*;
import org.osflash.signals.*;

/**
 * Conteneur liste de bouttons
 * 
 * @langversion ActionScript 3
 * @playerversion Flash 9.0.0
 * 
 * @author Christopher Corbin
 * @since  31.10.2010
 */
internal class ButtonList extends MiniGameBox
{
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------

		public function ButtonList ()
		{
			super(0, 0, {direction:"vertical", verticalGap:2})
			percentWidth = 100;
			addEventListener(MouseEvent.CLICK, handleClick);
		}
		
		public var entrySelected:Signal = new Signal();
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		public function addButton (button:SButton) : void
		{ addChild(button); }
		
		public function removeButton (button:SButton) : void
		{ if (contains(button)) removeChild(button); }

		//---------------------------------------
		// PRIVATE & PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * Réception cliques
		 *	@param e MouseEvent
		 */
		protected function handleClick (e:MouseEvent) : void
		{
			var t:Object = e.target;
			if (t is SButton) entrySelected.dispatch(t);
		}
		
}

import flash.text.*;

/**
 * Text info
 * 
 * @langversion ActionScript 3
 * @playerversion Flash 9.0.0
 * 
 * @author Christopher Corbin
 * @since  02.11.2010
 */
internal class InfoText extends TextField {
	
	//---------------------------------------
	// CONSTRUCTOR
	//---------------------------------------
	
	public function InfoText (text:String, width:int)
	{
		super();

		embedFonts = true;
		multiline = true;
		wordWrap = true;
		selectable = false;

		var tf:TextFormat = new TextFormat();
		tf.font = "Verdana";
		tf.size = 14;
		tf.color = 0xFFFFFF;
		tf.align = "left";
		defaultTextFormat = tf;
		
		this.width = width;
		this.text = text;
	}
	
	//---------------------------------------
	// PRIVATE VARIABLES
	//---------------------------------------
	
	//---------------------------------------
	// GETTER / SETTERS
	//---------------------------------------
	
	override public function set text (val:String) : void
	{
		super.htmlText = val;
		height = textHeight + 14;
	}
	
	public var includeInLayout = true;
	
}

import flash.text.*;

/**
 * Label coût
 * 
 * @langversion ActionScript 3
 * @playerversion Flash 9.0.0
 * 
 * @author Christopher Corbin
 * @since  01.11.2010
 */
internal class CostLabel extends MiniGameBox {
	
	//---------------------------------------
	// CONSTRUCTOR
	//---------------------------------------
	
	public function CostLabel ()
	{
		super();
		setStyle("direction", "horizontal");
		setStyle("horizontalAlign", "right");
		setStyle("paddingRight", 20);
		percentWidth = 100;
	}
	
	//---------------------------------------
	// PRIVATE & PROTECTED METHODS
	//---------------------------------------
	
	/**
	 * @inheritDoc
	 */
	override protected function drawChildren () : void
	{
		super.drawChildren();
		
		// label
		var tfd:TextField = new TextField();
		tfd.embedFonts = true;
		tfd.multiline = false;
		tfd.wordWrap = false;
		tfd.selectable = false;
		tfd.autoSize = TextFieldAutoSize.LEFT;

		var tf:TextFormat = new TextFormat();
		tf.font = "Verdana";
		tf.size = 14;
		tf.color = 0x000000;
		tf.align = "left";
		tfd.defaultTextFormat = tf;

		tfd.text = "coût";

		addChild(tfd);
	}
	
}

/**
 * Boutton choix destination
 * 
 * @langversion ActionScript 3
 * @playerversion Flash 9.0.0
 * 
 * @author Christopher Corbin
 * @since  31.10.2010
 */
internal class DButton extends SButton {
	
	public static var styles:Object =	{fontFamily:"Verdana",
													backgroundColor:0x3D1E2C,
//													horizontalGap:16,
													fontSize:15,
													cornerRadius:16,
													over:{backgroundColor:0x3D1829}};
	
	//---------------------------------------
	// CONSTRUCTOR
	//---------------------------------------
	
	public function DButton (label:String, data:Object)
	{
		super(0, 34, styles);
		percentWidth = 100;
		this.data = data;
		this.label = label;
	}
	
	//---------------------------------------
	// PRIVATE & PROTECTED INSTANCE VARIABLES
	//---------------------------------------
	
	public var data:Object;
	
	//---------------------------------------
	// PRIVATE & PROTECTED METHODS
	//---------------------------------------
	
}


import flash.display.Bitmap;
import flash.text.*;
import flash.events.MouseEvent;
import gs.TweenMax;
import gs.easing.*;

/**
 * Boutton choix transport
 * 
 * @langversion ActionScript 3
 * @playerversion Flash 9.0.0
 * 
 * @author Christopher Corbin
 * @since  31.10.2010
 */
internal class TButton extends DButton {
	
	[Embed(source="../../../assets/transports/voiture.png")]
	public var voiture:Class;
	[Embed(source="../../../assets/transports/train.png")]
	public var train:Class;
	[Embed(source="../../../assets/transports/metro.png")]
	public var metro:Class;
	[Embed(source="../../../assets/transports/tram.png")]
	public var tram:Class;
	[Embed(source="../../../assets/transports/avion.png")]
	public var avion:Class;	
	[Embed(source="../../../assets/transports/bus.png")]
	public var bus:Class;	
	[Embed(source="../../../assets/transports/covoiture.png")]
	public var covoiture:Class;	
	[Embed(source="../../../assets/transports/velo.png")]
	public var velo:Class;
	
	//---------------------------------------
	// CONSTRUCTOR
	//---------------------------------------
	
	public function TButton (label:String, data:Object, costColor:uint = 0xF7BC00, toolTip:String = null)
	{
		_costColor = costColor;
		super(label, data);
		setStyle("align", "left");
		setStyle("paddingLeft", 0);
		setStyle("icon", new this[data.icon]);
		
		var cost:int = data.ecost;
		if (cost != 0)
			this.costLabel = cost + " éco";
		
		if (toolTip)
		{
			_toolTipText = toolTip;
			addEventListener(MouseEvent.CLICK, handleMouse, false, 0, true);
		}
	}
	
	//---------------------------------------
	// PRIVATE & PROTECTED INSTANCE VARIABLES
	//---------------------------------------
	
	protected var _toolTipText:String;
	protected var _toolTip:TButtonTooltip;
	protected var _costColor:uint;
	protected var _costLabel:TextField;
	private static var clStyle:Object = {direction:"horizontal", horizontalAlign:"right", paddingLeft:100, paddingRight:10};
	
	//---------------------------------------
	// GETTER / SETTERS
	//---------------------------------------
	
	public function set costLabel (val:String) : void
	{ 
		_costLabel.text = val;
		invalidateSize();
	}
	
	//---------------------------------------
	// EVENT HANDLERS
	//---------------------------------------
	
	/**
	 * @inheritDoc
	 */
	override protected function handleMouse (event:MouseEvent) : void
	{
		super.handleMouse(event);
		if (!_toolTipText) return;
		
		switch (event.type)
		{
			case MouseEvent.CLICK :
				if (!_toolTip)
				{
					_toolTip = new TButtonTooltip(_toolTipText);
					var bds:Object = getBounds(stage);
					_toolTip.x = bds.right - 10;
					_toolTip.y = bds.top + 10;
					stage.addChild(_toolTip);
					TweenMax.from(_toolTip, 0.3, {width:0, height:0, ease:Back.easeOut});
				}
				break;
			case MouseEvent.MOUSE_OUT :
				if (_toolTip)
				{
					stage.removeChild(_toolTip);
					_toolTip = null;
				}
				break;
		}
	}
	
	//---------------------------------------
	// PRIVATE & PROTECTED METHODS
	//---------------------------------------
	
	/**
	 * @inheritDoc
	 */
	override protected function drawChildren () : void
	{
		super.drawChildren();
		
		var cont:MiniGameBox = new MiniGameBox(0, 0, clStyle);
		cont.percentWidth = 100;
		
		// label
		_costLabel = new TextField();
		_costLabel.embedFonts = true;
		_costLabel.multiline = false;
		_costLabel.wordWrap = false;
		_costLabel.selectable = false;
		_costLabel.autoSize = TextFieldAutoSize.LEFT;
		
		var tf:TextFormat = new TextFormat();
		tf.font = "MgUIFont";
		tf.size = _styles.fontSize - 1;
		tf.color = _costColor;
		tf.align = "right";
		_costLabel.defaultTextFormat = tf;
		
//		_costLabel.filters = [glow];
		
		cont.addChild(_costLabel);
		addChild(cont);
	}
	
}

import flash.display.Sprite;
import flash.text.*;
import flash.filters.DropShadowFilter;

internal class TButtonTooltip extends Sprite {
	
	public static var fx:DropShadowFilter = new DropShadowFilter();
	
	//---------------------------------------
	// CONSTRUCTOR
	//---------------------------------------
	
	public function TButtonTooltip (text:String) : void
	{
		super();
		
		var w:int = 160;
		
		var tf:TextFormat = new TextFormat();
		tf.font = "MgUIFont";
		tf.align = "center";
		tf.size = 14;
		
		var tfd:TextField = new TextField();
		tfd.defaultTextFormat = tf;
		tfd.embedFonts = true;
		tfd.autoSize = "left";
		tfd.multiline = true;
		tfd.wordWrap = true;
		tfd.width = w - 20;
		tfd.text = text;

		// > ombre et fond
		var dw:int = tfd.height / 2;
		
		graphics.clear();
		graphics.beginFill(0xFFFFFF, 1);
		graphics.drawRoundRect(0, -(tfd.height + 20), w, tfd.height + 20, 20);
		graphics.endFill();
		graphics.beginFill(0xFFFFFF, 1);
		graphics.moveTo(0, 0);
		graphics.lineTo(0, -20);
		graphics.lineTo(20, 0);
		graphics.endFill();
		
		tfd.x = 10;
		tfd.y = -(tfd.height + 10);
		addChild(tfd);
		
		filters = [fx];
	}
	
	public var includeInLayout:Boolean = false;
	
}