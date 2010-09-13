package ddgame.client.triggers {
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.display.Loader;

	import com.sos21.events.BaseEvent;
	import ddgame.client.events.EventList;
	import ddgame.client.triggers.AbstractTrigger;

	import com.hurlant.eval.Evaluator;
	import com.hurlant.eval.ByteLoader;

	/**
	 *	Trigger ajout bonus
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class ScriptTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 104;
		
		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		override public function execute (e:Event = null) : void
		{
			var wrap:Array =
			[	"public class TScript { ",
				"public var facade:Object;",
				"public var trigger:Object;",
				"public var isoSH:Object;",
				"public var bob:Object;",
				getPropertie("script"),
				"}"	];

			var src:String = wrap.join('');
	    	var evaluator:Evaluator = new Evaluator();
        	var bytes:ByteArray = evaluator.eval(src);

			loadBytes(ByteLoader.wrapInSWF([bytes]));
//			complete();
		}
		
		public function _complete () : void
		{
			complete();
		}
		
		private function loadBytes(bytes:*, inplace:Boolean = false) : Boolean
		{
			var l:Loader = new Loader;
			// TODO, écoute des erreurs
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoader);
			l.loadBytes(bytes);
			return true;
		}
		
		private function handleLoader (e:Event) : void
		{
			e.target.removeEventListener(Event.COMPLETE, handleLoader);
			var cl:Class = e.target.applicationDomain.getDefinition( "TScript" ) as Class;
			var t:Object = new cl();
			t.facade = facade;
			t.trigger = this;
			t.isoSH = facade.getObserver("isosceneHelper");
			t.bob = facade.getObserver("playerHelper");
			t.execute();
		}
		
	}

}

