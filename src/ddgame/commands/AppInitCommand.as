/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.commands {
	
	import flash.events.Event;	
	import flash.system.ApplicationDomain;
	
	import nl.demonsters.debugger.MonsterDebugger;

	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	import com.sos21.events.BaseEvent;
	import com.sos21.proxy.ConfigProxy;	
	import com.sos21.helper.AbstractHelper;

	import ddgame.events.EventList;

	import ddgame.helper.HelperList;
	import ddgame.commands.OpenMapScreenCommand;

	import ddgame.proxy.ProxyList;
	import ddgame.proxy.UserProxy;
	import ddgame.ui.ProgressLogoHelper;
	import ddgame.ui.UIHelper;
	import ddgame.sound.AudioHelper;

	import ddgame.proxy.ProxyList;
	import ddgame.server.IClientServer;
	import ddgame.events.ServerEventList;
	import ddgame.commands.*;
	import ddgame.ui.MapScreenHelper;
	
	/**
	 *	Commande initialisation de l'appli, effectue
	 * 
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class AppInitCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute(event:Event):void
		{
			// récup des data
			var evtContent:Object = BaseEvent(event).content;
			
			// déclaration proxys
			facade.registerProxy(ConfigProxy.NAME, ConfigProxy.getInstance());

			// On passe la ref du stage aux AbstractHelper
			AbstractHelper.stage = evtContent.documentRoot;
			
			// initialiation de l'interface
			// check si on à une ui
			var uiClass:Class
			try
			{
				uiClass = ApplicationDomain.currentDomain.getDefinition("ddgame.display.ui.UI") as Class;
			} catch (e:Error) { }
			 
			if (uiClass)
				facade.registerObserver(UIHelper.NAME, new UIHelper(new uiClass));
			
			// initialiation helper audio
			facade.registerObserver(AudioHelper.NAME, new AudioHelper());
			// init helper carte déplacement
			facade.registerObserver(MapScreenHelper.NAME, new MapScreenHelper());
			facade.registerCommand(EventList.OPEN_MAPSCREEN, OpenMapScreenCommand);
			
			// TODO KK
			var pr:ProgressLogoHelper = new ProgressLogoHelper();
			facade.registerObserver(ProgressLogoHelper.NAME, pr);
						
			// initialization clientServer et recup des datas utilisateur
			var credentials:Object = evtContent.userCredentials;
			if (credentials)
			{
				// initialization clientServer
				var serverProxy:Object	= evtContent.clientServer;
				facade.registerProxy(ProxyList.SERVER_PROXY, serverProxy as IClientServer);
				serverProxy.connect(credentials);
				
				// on enregistre les commandes serveur
				facade.registerCommand(ServerEventList.GET_DATAMAP, ddgame.commands.GetDataMapCommand, true);
				facade.registerCommand(ServerEventList.GET_DATAQUIZ, ddgame.commands.GetDataQuizCommand, true);
				facade.registerCommand(ServerEventList.GET_MAPLIST, ddgame.commands.GetMapListCommand, true);

				// lancement recupération des données utilisateur
				serverProxy.getUserData(credentials.login, credentials.password);
				
				if (ConfigProxy.getInstance().getContent("debug") == "true")
				{
				}
				
				trace(this, "Application initialized");
			}
			else
			{
				throw new Error("Acune autorisation utilisateur, application stopée");
			}						
		}
		
	}
	
}