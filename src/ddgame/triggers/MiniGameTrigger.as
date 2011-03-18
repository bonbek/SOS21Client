package ddgame.triggers {
	
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;

	import gs.TweenMax;
	import gs.easing.*
	import gs.plugins.*;
	import br.com.stimuli.loading.BulkLoader;
	
	import ddgame.triggers.AbstractTrigger;
	import ddgame.scene.IsosceneHelper;
	import ddgame.ui.UIHelper;
	import ddgame.display.MiniProgressBar;
	import ddgame.minigame.IMiniGame;	
	
	/**
	 *	Trigger mini jeu
	 * 
	 * arguments :
	 * - gf : url du fichier jeu (obligatoire)
	 * - df : url du fichier de données (optionel)
	 * - cf : config du jeu (optionel)
	 * - sc : couleur 'scène shoot color' capture la scène active et en fait un fond monochrome de jeu (optionel)
	 * - sb : couleur 'scène shoot brightness' luminosité de la capture
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class MiniGameTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 101;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		// helper isoscene
		private var isosceneHelper:IsosceneHelper;
		// loader jeu / config ... resources ?
		private var loader:BulkLoader;
		// barre de chargement;
		private var progressBar:MiniProgressBar;
		// fond du jeu
		private var bgGame:Sprite;
		// jeu
		private var _game:IMiniGame;
		// options de chargement
//		private var loadOpts:Object = {preventCache:true, context:new LoaderContext(false, ApplicationDomain.currentDomain)};
//		private var loadBinOpts:Object = {preventCache:true, context:new LoaderContext(false, ApplicationDomain.currentDomain), type:BulkLoader.TYPE_BINARY};		

		private var loadOpts:Object = {preventCache:true};
		private var loadBinOpts:Object = {preventCache:true, type:BulkLoader.TYPE_BINARY};		

		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Retourne l'url du fichier jeu
		 */
		public function get gameFile () : String
		{
			return getPropertie("gf");
		}
		
		/**
		 * Retourne le l'instance du jeu
		 */
		public function get game () : IMiniGame
		{
			return _game;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 * Entrée du trigger
		 */
		override public function execute (event:Event = null) : void
		{
			// check des paramètres / options passés à ce trigger
			if (!isPropertie("gf"))
			{
				super.complete();
				return;
			}
			
			// recup de du helper isoscene
			isosceneHelper = facade.getObserver(IsosceneHelper.NAME) as IsosceneHelper;			
			// freeze
			isosceneHelper.freezeScene();
			
			// affichage fond du jeu
			/*var c:uint = getPropertie("sc");
			if (c) drawDefaultGameBackground(c, getPropertie("sb"));*/

			var sc:Object = getPropertie("sc");
			if (sc) drawDefaultGameBackground(sc);
			
			// on crée le loader si besoin
			if (!BulkLoader.getLoader("minigame"))  loader = new BulkLoader("minigame");
			else
				loader = BulkLoader.getLoader("minigame");

			// chargement du descripteur avant jeu afin de recup les asssets à preloader
			if (isPropertie("df")) loadDescriptor();
			else
				loadGame();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * Réception event chargement du jeu 
		 *	@param e Event
		 */
		private function handleLoader (e:Event) : void
		{
			switch (e.type)
			{
				case Event.COMPLETE :
				{
					loader.removeEventListener(Event.COMPLETE, handleLoader, false);
					TweenMax.to(progressBar, 1, {alpha:0, onComplete:fireGame});
					break;
				}
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@private
		 * Affichage fond par défaut du mini-jeu
		 * Reprise de la scène en cours avec un effet de couleur
		 */
//		private function drawDefaultGameBackground (col:uint=0x8A7177, bright:Number = 4) : void
		private function drawDefaultGameBackground (params:Object) : void
		{
			// recup de la scène
			var scene:DisplayObject = isosceneHelper.component;
			// dimensions de la scène
			var sWidth:int = UIHelper.VIEWPORT_AREA.width;
			var sHeight:int = UIHelper.VIEWPORT_AREA.height;
			
			// mise en place du fond du jeu (reprise de la scène en cours
			// avec un effet couleur)
			bgGame = new Sprite();
			bgGame.x = UIHelper.VIEWPORT_AREA.x;
			bgGame.y = UIHelper.VIEWPORT_AREA.y;			
			
			var srcBmp:BitmapData = new BitmapData(sWidth, sHeight);	
			srcBmp.draw(scene);			
			bgGame.graphics.beginBitmapFill(srcBmp);
			bgGame.graphics.drawRect(0, 0, sWidth, sHeight);
			bgGame.graphics.endFill();
			
			stage.addChild(bgGame);
			
			// effet animé
//			TweenMax.to(bgGame, 1, {colorMatrixFilter:{colorize:col, amount:1, brightness:bright}, ease:Strong.easeInOut});
			for each (var p:Object in params) trace("FILTER", p);
			TweenMax.to(bgGame, 1, {colorMatrixFilter:params, ease:Strong.easeInOut});
		}
		
		/**
		 *	@private
		 * Lance le chargement du jeu, sa config, ...ses ressources ?
		 * Aucune vérif n'est faite sur les paramètres étant
		 * entendu que celle-ci est effectuée par la méthode execute()
		 */
		private function loadGame (e:Event = null) : void
		{
			// on revient du chargement du descripteur
			if (e)
			{
				loader.removeEventListener(Event.COMPLETE, loadGame, false);
				
				// on essaie de retrouver tous les assets à loader			
				try
				{
					var desc:Object = loader.getContent(getPropertie("df"));
					var list:Object;
					var path:Array;
					var atInd:int;
					var af:String;
					for each (var n:Object in desc.preload)
					{
						list = desc;
						atInd = n.indexOf("@");
						
						if (atInd == -1) {
							path = n.split(".");
							atInd = 0;
						} else { path = n.substring(0, atInd).split("."); }
						
						for (var i:int = 0; i < path.length; i++)
							list = list.child(path[i]);
						
						// ajout au loader
						for each (var asset:Object in list) {
							af = asset.@f;
							// chargement format binaire si attribut b
							loader.add(af, ("@b" in asset) ? loadBinOpts : loadOpts);
						}
					}
				} catch (e:Error) { trace(this, "Erreur recup descripteur"); }
			}

			// jeu
			loader.add(gameFile, loadOpts);
			loader.addEventListener(Event.COMPLETE, handleLoader, false);
			
			// barre de progression
			progressBar = new MiniProgressBar();
			progressBar.suscribe(loader);
			progressBar.x = UIHelper.VIEWPORT_AREA.x + ((UIHelper.VIEWPORT_AREA.width - progressBar.width) / 2);
			progressBar.y = UIHelper.VIEWPORT_AREA.y + ((UIHelper.VIEWPORT_AREA.height - progressBar.height) / 2);
			stage.addChild(progressBar);
			// fx
			TweenMax.from(progressBar, 1, {tint:0xFFFFFF});
			
			// on charge
			loader.start();
		}
		
		private function loadDescriptor () : void
		{
			loader.addEventListener(Event.COMPLETE, loadGame, false);
			loader.add(getPropertie("df"), loadOpts);
			loader.start();
		}
		
		/**
		 *	@private
		 * Chargement des ressources effectué
		 */
		private function fireGame () : void
		{
			stage.removeChild(progressBar);
			progressBar = null;
			
			// jeu
			_game = loader.getContent(gameFile) as IMiniGame;
			_game.setTrigger(this);
			// data
			if (isPropertie("df")) _game.setData(loader.getContent(getPropertie("df")));
				
			_game.view.x = UIHelper.VIEWPORT_AREA.x;
			_game.view.y = UIHelper.VIEWPORT_AREA.y;
			stage.addChild(_game.view);
			
			_game.leave.addOnce(complete);
			
			_game.start();
		}

		/**
		 * @inheritDoc
		 */
		override protected function complete (e:Event = null) : void
		{
			if (_game)
			{
				_game.release();
				TweenMax.to(_game.view, 0.5, {alpha:0, ease:Back.easeInOut, onComplete:stage.removeChild, onCompleteParams:[_game]});				
			}
			if (bgGame) 
			{
				TweenMax.to(bgGame, 0.5, {alpha:0, ease:Back.easeInOut, onComplete:stage.removeChild, onCompleteParams:[bgGame]});
				bgGame = null;
			}
			isosceneHelper.unfreezeScene();
			if (loader)
			{
				loader.clear();
			}
			
			super.complete(e);
		}
	
	}

}