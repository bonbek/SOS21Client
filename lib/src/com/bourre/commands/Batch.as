package com.bourre.commands 
{
	/**
	 * <code>Batch</code> object encapsulate a set of <code>Commands</code>
	 * to execute at the same time.
	 * 
	 * <p>Batch is a first-in first-out stack (FIFO) where commands
	 * are executed in the order they were registered.</p>
	 * 
	 * <p>When an event is passed to the <code>execute</code> method
	 * it will be relayed to the sub-commands.</p>
	 * 
	 * @author 	Cédric Néhémie
	 * @version 1.0
	 * @see		MacroCommand
	 */

	import flash.events.Event;

	public class Batch implements MacroCommand
	{
		protected var _aCommands : Array;

		/**
         * Takes all elements of an Array and pass them one by one as arguments
         * to a method of an object.
         * It's exactly the same concept as batch processing in audio or video
         * software, when you choose to run the same actions on a group of files.
         *
         * <p>Basical example which sets _alpha value to .4 and scale to 50
         * on all MovieClips nested in the Array :
         *
         * @example
         * <code>
         * import com.bourre.commands.*;
         *
         * function changeAlpha( mc : MovieClip, a : Number, s : Number )
         * {
         *      mc._alpha = a;
         *      mc._xscale = mc._yscale = s;
         * }
         *
         * Batch.process( changeAlpha, [mc0, mc1, mc2], .4, 50 );
         * </code>
         *
         * @param f Function to run.
         * @param a Array of parameters.
         */
		public static function process(f:Function, a:Array, ...aArgs) : void
		{
			var l : Number = a.length;
			while( --l > -1 ) f.apply( null, (aArgs.length > 0 ) ? [a[l]].concat( aArgs ) : [a[l]] );
		}

		/**
		 * Batch object don't accept any arguments in the constructor.
		 */
		public function Batch ()
		{
			_aCommands = new Array();
		}

		/**
		 * Add a command in the batch stack.
		 * 
		 * <p>If the passed-in command have been added the
		 * function return <code>true</code>.</p> 
		 * 
		 * <p>There is no limitation on the number of references
		 * of the same command witch the batch can contain.</p>
		 * 
		 * @param oCommand	A <code>Command</code> to add at the end
		 * 					of the current Batch. 
		 * @return <code>true</code> if the command could have been added.
		 * 		   either <code>false</code>
		 */
		public function addCommand( oCommand : Command ) : Boolean
		{
			if( oCommand == null ) return false;

			var l : Number = _aCommands.length;
			return (l != _aCommands.push( oCommand ) );
		}

		/**
		 * Remove all references to the passed-in command.
		 * 
		 * <p>If the command have been found and removed
		 * from the <code>Batch</code> the function return
		 * <code>true</code>.</p>
		 * 
		 * @param oCommand 
		 * @return <code>true</code> if the command have been 
		 * 		   successfully removed.
		 * 
		 */
		public function removeCommand( oCommand : Command ) : Boolean
		{
			var id : Number = _aCommands.indexOf( oCommand ); 

			if ( id == -1 ) return false;
			
			while ( ( id = _aCommands.indexOf( oCommand ) ) != -1 )
			{
				_aCommands.splice( id, 1 );
			}
			return true;
		}

		/**
		 * Returns <code>true</code> if the passed-in command is stored
		 * in the <code>Batch</code>.
		 * 
		 * @param  oCommand Command to look at
		 * @return <code>true</code> if the passed-in command is stored
		 * 		   in the <code>Batch</code>.
		 */
		public function contains ( oCommand : Command ) : Boolean
		{
			return _aCommands.indexOf( oCommand ) != -1;
		}

		/**
		 * Execute the whole set of commands in the order they were
		 * registered.
		 * 
		 * <p>If an event is passed to the function, it will be relayed
		 * to the sub-commands <code>execute</code> method.</p>
		 * 
		 * @param	e	An event that will be relayed to the sub-commands. 
		 */
		public function execute( e : Event = null ) : void
		{
			var l : Number = _aCommands.length;

			if( l == 0 ) return;

			for( var i : Number = 0; i<l; i++ ) 
			{
				( _aCommands[ i ] as Command ).execute( e );
			}
		}

		/**
		 * Remove all commands stored in the batch stack.
		 */
		public function removeAll () : void
		{
			_aCommands = new Array();
		}

		/**
		 * Returns the number of commands stored in the Batch.
		 * 
		 * @return the number of commands stored in the Batch.
		 */
		public function getLength () : uint
		{
			return _aCommands.length;		
		}	
	}
}