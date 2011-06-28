/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.commands {
	import flash.events.Event;
	import com.sos21.debug.log;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  23.01.2008
	 */
	public class MacroCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function MacroCommand()
		{
			initialize();
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _cList:Array = [];
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute(event:Event):void
		{
			while (_cList.length > 0)
			{
				var command:ICommand = new (Class(_cList.shift()));
				if (command is Notifier)
					Notifier(command).channel = channel;
					
				command.execute(event);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function addCommand(c:Class):void
		{
			_cList.push(c);
		}
		
		
		protected function initialize():void
		{ trace("initialize should be implented in your subClass @" +toString()); }
		
	}
	
}
