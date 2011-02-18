package ddgame.client.commands {

	import flash.events.Event;
	import com.sos21.events.BaseEvent;
	import com.sos21.observer.Notifier;
	import com.sos21.commands.ICommand;	
	import ddgame.client.proxy.EnvProxy;
	
	/**
	 *	Ecrit une variable global
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  15.12.2010
	 */
	public class WriteEnvCommand extends Notifier implements ICommand {
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		public function execute (event:Event) : void
		{
			var o:Object = BaseEvent(event).content;

			// check si params obligatoires existent
			if (!("k" in o) || !("v" in o)) return;

			var penv:EnvProxy = EnvProxy(facade.getProxy(EnvProxy.NAME));

			// recup valeur à affecter en passant par proxy
			// au cas ou cette valeur soit un "objet de l'appli" 
			var nv:* = o.v is String ? penv.get(o.v) : o.v;

			// check si param méthode
			if ("m" in o)
			{

				// valeur original
				var oval:* = penv.get(o.k);

				if (!oval)
				{
					// pas de valeur original, on la crée / écrie ?
					penv.set(o.k, nv);
					return;
				}

				switch (o.m)
				{
					// ajout à la var
					case "add" :
					{
						if (oval is Array) penv.set(o.k, oval.concat(nv));
						else
							penv.set(o.k, oval + nv);
						break;
					}
					// soustraction à la var
					case "sub" :
					{
						if (oval is Array)
						{
							var olen:int = oval.length;
							if (!(nv is Array)) nv = [nv];

							var ind:int;
							for each (var v:* in nv.splice(0))
							{
								ind = oval.indexOf(v);
								if (ind > -1) oval.splice(ind, 1);
							}

							if (oval.length < olen) penv.set(o.k, oval);
						}
						else
						{
							penv.set(o.k, oval - nv);
						}
						break;
					}
					// multiplication de la var
					case "mul" :
					{
						if (!(oval is Array))
							penv.set(o.k, oval * nv);
						break;
					}
					// division de la var
					case "div" :
					{
						if (!(oval is Array))
							penv.set(o.k, oval / nv);
						break;
					}
					default :
						penv.set(o.k, nv);
						break;
				}
			}
			else
			{
				// pas de méthode
				penv.set(o.k, nv);
			}
		}
	
	}

}