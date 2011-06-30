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
		
		/**
		 * Applique un retour d'erreur
		 *	@param document IDatabaseDocument
		 *	@param params Object
		 *	@param successCallBack Function
		 *	@param faultCallBack Function
		 */
		public function save (document:IDatabaseDocument, params:Object = null, successCallBack:Function = null, faultCallBack:Function = null) : void
		{
			trace(this, "save");
			if (faultCallBack != null) faultCallBack.apply(null, [null]);
		}

		/**
		 * Applique un retour d'erreur
		 *	@param successCallBack 	foncion de rappel en cas reussite
		 *	@param faultCallBack 	function de rappel en cas d'echec
		 */
		public function destroy (document:IDatabaseDocument, successCallBack:Function = null, faultCallBack:Function = null) : void
		{
			trace(this, "destroy");
			if (faultCallBack != null) faultCallBack.apply(null, [null]);
		}
		
	
	}

}

