package {
	
	import flash.display.Sprite;
	import com.sos21.proxy.ConfigProxy;
	import ddgame.ApplicationFacade;
	
	
	/**
	 *	Point d'entrée de l'application
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	
	[SWF(width="980", height="576", backgroundColor="#000000", frameRate=25)]
	public class client extends Sprite {
				
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		public function client ()
		{
			super();
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Point de lancement de l'application.
		 *	@param config XML		configuration de l'application
		 * @param clientServer	module IClientServer
		 *	@param credentials 	Identifiants utilisateur loggé (email et mot de passe encrypté)
		 * @return		la facade de l'application
		 */
		public function startup (config:XML, clientServer:Object, userCredentials:Object = null) : ApplicationFacade
		{
			ConfigProxy.getInstance().setData(config);
			var facade = ApplicationFacade.getInstance();
			facade.startup(this, clientServer, userCredentials ? userCredentials : {login:"guest", password:"35675e68f4b5af7b995d9205ad0fc43842f16450"});

			return facade;
		}
		
	}
	
}
