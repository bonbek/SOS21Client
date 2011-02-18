package ddgame.client.commands {
	
	import flash.events.Event;
	
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;
	
	import ddgame.client.events.EventList;
	import ddgame.server.events.PublicServerEventList;
	import ddgame.client.proxy.PlayerProxy;
	import ddgame.server.proxy.RemotingProxy;
	import ddgame.vo.Bonus;

	/**
	 *	Command ajout / suppression de points
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class AddBonusCommand extends Notifier implements ICommand {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function execute (event:Event) : void
		{
			var d:Object = BaseEvent(event).content;
			
			switch (event.type)
			{
				// > ajout de points, passage côté serveur
				case EventList.ADD_BONUS :
				{
					if (d.bonus is int)
					{
						if (d.bonus != 0)
							RemotingProxy(facade.getProxy(RemotingProxy.NAME)).playerBonus({theme:d.theme, gain:d.bonus});
//							PlayerProxy(facade.getProxy(PlayerProxy.NAME)).addBonus(new Bonus(d.theme, d.bonus));
						break;						
					}
				}
				// > les points on été ajoutés
				case PublicServerEventList.ON_BONUS_ADDED :
				{
					trace(this, "----------------------");
					for (var p:String in d)
						trace(p, d[p]);
					
					var pp:PlayerProxy = PlayerProxy(facade.getProxy(PlayerProxy.NAME));
					// test si le niveau à changé
					if (pp.level != d.bonus[0] || pp.classe != d.classe)
					{
						trace("info", "classe or level changed");
						pp.classe = d.classe;
//						pp.level = d.level;
						// niveau
						pp.level = d.bonus[0];
						// points piraniak
						pp.setBonus(new Bonus(1, d.bonus[1]));
						// points social
						pp.setBonus(new Bonus(2, d.bonus[2]));
						// points éco
						pp.setBonus(new Bonus(3, d.bonus[3]));
						// points environnement
						pp.setBonus(new Bonus(4, d.bonus[4]));
					}
					else
					{
						// calcul diff entre points actuels du player et ceux mis
						// à jour
						var bpir:int = d.bonus[1] - pp.getBonus(1).gain;
						var bsoc:int = d.bonus[2] - pp.getBonus(2).gain;
						var beco:int = d.bonus[3] - pp.getBonus(3).gain;
						var benv:int = d.bonus[4] - pp.getBonus(4).gain;
						pp.addBonus(new Bonus(1, bpir));
						pp.addBonus(new Bonus(2, bsoc));
						pp.addBonus(new Bonus(3, beco));
						pp.addBonus(new Bonus(4, benv));
						trace('dif bpir:' + bpir, 'dif bsoc:' + bsoc, 'diff beco:' + beco, 'diff benv:' + benv);					
					}
					
					break;
				}
			}
			
			/*var pp:PlayerProxy = PlayerProxy(facade.getProxy(PlayerProxy.NAME));

			var bonus:Bonus = new Bonus(d.theme, d.bonus);
			pp.addBonus(bonus);
			// recup du total des point pour le theme
			var nb:int = pp.getBonus(d.theme).gain;
			var prop:Object = {};
			switch (d.theme)
			{
				case 2 :
					prop.b_soc = nb;
					break;
				case 3 :
					prop.b_eco = nb;
					break
				case 4 :
					prop.b_env = nb;
					break;				
			}
			trace(this, nb);
			RemotingProxy(facade.getProxy(RemotingProxy.NAME)).updatePlayer(pp.id, prop);*/
		}
				
	}
	
}
