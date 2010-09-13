/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.commands {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.ui.Mouse;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.helper.AbstractHelper;
	import ddgame.client.proxy.LibProxy;

	/**
	 *	sos21 Command Subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  20.03.2008
	 */
	public class DisplayHourglassCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute(event:Event):void
		{
			if (Boolean(BaseEvent(event).content) && hourGlass == null)
			{
				Mouse.hide();
				var classRef:Class = LibProxy(facade.getProxy(LibProxy.NAME)).lib.getClassFrom("uis/widgets.swf", "Hourglass");
				hourGlass = new classRef();
				AbstractHelper.stage.addEventListener(MouseEvent.MOUSE_MOVE, hourGlassMouseHandler, false, 0, true);
				AbstractHelper.stage.addChild(hourGlass);
				hourGlass.x = AbstractHelper.stage.mouseX;
				hourGlass.y = AbstractHelper.stage.mouseY;
			}
			else if (hourGlass != null)
			{
				AbstractHelper.stage.removeEventListener(MouseEvent.MOUSE_MOVE, hourGlassMouseHandler);
				AbstractHelper.stage.removeChild(hourGlass);
				hourGlass = null;
				Mouse.show();
			}
		}
		
		private static var hourGlass:MovieClip;
		public static function hourGlassMouseHandler(event:MouseEvent = null):void
		{
			hourGlass.x = AbstractHelper.stage.mouseX;
			hourGlass.y = AbstractHelper.stage.mouseY;
			event.updateAfterEvent();
		}
				
	}
	
}
