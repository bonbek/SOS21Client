package ddgame.server {
	
	import ddgame.server.IDatabaseDocument;
	
	/**
	 *	Document null
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  28.06.2011
	 */
	public class NullDocument implements IDatabaseDocument {
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get id () : String
		{ return null; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		public function save (	params:Object = null,
										successCallBack:Function = null,
										faultCallBack:Function = null) : void
		{
			trace(this, "save");
		}
		
		public function destroy (successCallBack:Function = null, faultCallBack:Function = null) : void
		{
			trace(this, "destroy");
		}
	
	}

}

