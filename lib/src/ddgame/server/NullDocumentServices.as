package ddgame.server {

	import ddgame.server.NullDocument;

	/**
	 *	Services de document null
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  23.06.2011
	 */
	public class NullDocumentServices implements IDocumentServices {
		
		//---------------------------------------
		// PRIVATE VARIABLES
		//---------------------------------------
		
		private var document:NullDocument = new NullDocument();
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Applique un retour d'erreur
		 *	@param params Object
		 *	@param successCallBack Function
		 *	@param faultCallBack Function
		 */
		public function load (	params:Object, successCallBack:Function = null,
										faultCallBack:Function = null	) : void
		{
			trace(this, "load");
			if (faultCallBack != null) faultCallBack.apply(null, [null]);
		}
		
		/**
		 * Retourne un objet null
		 *	@param params Object
		 *	@return IDatabaseDocument
		 */
		public function create (params:Object = null) : IDatabaseDocument
		{
			trace(this, "create");
			return document;
		}
	
	}

}

