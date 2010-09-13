package ddgame.proxy {
	
	import com.sos21.proxy.AbstractProxy;
	
	import ddgame.proxy.ProxyList;	
	import ddgame.vo.ITheme;
	import ddgame.vo.Theme;
	
	/**
	 *	Proxy application
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class ApplicationProxy extends AbstractProxy {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function ApplicationProxy (name:String, data:Object)
		{
			super(name, data);
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _themeList:Array;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get themes () : Array
		{
			return _themeList.concat();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function getTheme (id:int) : ITheme
		{
			return _themeList[id];
		}
		
		/**
		 *	@private
		 */
		public function initialize () : void
		{
			// compil des themes
			var th:Theme;
			_themeList = [];
			var tl:XMLList = _data.themes.theme;
			for each (var n:XML in tl)
			{
				th = new Theme(n.@id, n.color[0], n.title[0]);
				_themeList[th.id] = th;
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}

