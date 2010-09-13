/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.view {

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import gs.TweenLite;
	import caurina.transitions.Equations;
	import com.sos21.debug.log;
	import com.sos21.proxy.ConfigProxy;
	import com.sos21.events.BaseEvent;
	import com.sos21.helper.AbstractHelper;
	import ddgame.client.events.EventList;

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  16.04.2008
	 */
	public class UIBonusWidgetHelper extends AbstractHelper {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = HelperList.UIBONUSWIDGET_HELPER;

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function UIBonusWidgetHelper(oComponent:MovieClip)
		{
			super(NAME, oComponent);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		private var _bonusFactor:uint = 1;
		public function get bonusFactor():uint
		{ 
			return _bonusFactor; 
		}

		public function set bonusFactor(value:uint):void
		{
			if(value != _bonusFactor)
			{
				_bonusFactor = value;
			}
		}
		
		/**
		 * Additional getter to return the correct component type
		 */
		public function get component():MovieClip
		{
			return MovieClip(_component);
		}

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function resetAllBonus():void
		{
			var l:int = 4;
			for (var i:int = 1; i <= l; i++)
			{
				component["maskTheme" + i].scaleY = 0;
			}
		}
		
		public function updateJauges(themeId:int, val:Number):void
		{
			var mc:DisplayObject = component.getChildByName("maskTheme" + String(themeId));
			
			if (mc) {
				var dv:Number
				if (_bonusFactor > 0)
				 	dv = val * _bonusFactor / 100 + mc.scaleY;
			 	else
					dv = val / _bonusFactor / 100 + mc.scaleY;

				TweenLite.to(mc, 1, {scaleY:dv, ease:Equations.easeOutBounce});
			} else {
				trace("!! l'id du theme associé au bonus n'est pas bon - id du thème:" + themeId);
			}
		}
		
		
		override public function initialize():void
		{
			resetAllBonus();
			component.addEventListener(MouseEvent.ROLL_OVER, handleEvent, false, 0, true);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		/**
		 * Default Event handler
		 */
		override public function handleEvent(event:Event):void
		{
			switch (event.type)
			{
				case EventList.ADD_BONUS :
				{ 
					var d:Object = BaseEvent(event).content;
					updateJauges(int(d.theme), Number(d.bonus));
					break;
				}
				case MouseEvent.ROLL_OVER :
				{
//					ConfigProxy.getInstance().data.themes.theme.(@id == d.theme).title;
					trace("mouse over ", event.target);
					break;
				}
				default :
				break;
			}
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
				
		/**
		 * Call by super class
		 * List the Event interest this Helper is interested in
		 */
		override protected function listInterest():Array
		{
			return [EventList.ADD_BONUS];
		}

	}
	
}
