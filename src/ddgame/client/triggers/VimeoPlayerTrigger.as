package ddgame.client.triggers {
	
	import flash.geom.Rectangle;
	import flash.events.*;
	import flash.display.*;
	
	import br.com.stimuli.loading.BulkLoader;
	import com.sos21.media.VimeoPlayer;
	
	import ddgame.view.UIHelper;
	import ddgame.sound.AudioHelper;
	import ddgame.client.triggers.AbstractTrigger;

	
	/**
	 *	Trigger pour le player Viméo
	 * 
	 * arguments :
	 * 
	 * - al			>>> 'visionnage' d'un album
	 * 	- id		: identifiant de l'album
	 * 	- sds		: "show descrition at start" affiche la descrition de l'album au premier affichage
	 * 	- svls	: "show video list at start" affiche la liste des vidéos au premier affichage
	 * 	- vil		: "video to load" id de la vidéo à charger automatiquement		// TODO
	 * 
	 * - vid 		>>> 'visionnage' d'une vidéo												// TODO
	 * 	- id		: identifiant de la video
	 * 	- sds		: "show descrition at start" affiche la descrition de la vidéo (au premier affichage)
	 * 	- ast		: "autostart" démarre la lecture automatiquement
	 * 
	 * - pl			>>> option du player
	 * 	- c		: couleur du player
	 * 	- x		: coordonnée x du player
	 * 	- y		: coordonnée y du player
	 * 	- w		: largeur du player
	 * 	- h		: heuteur du player
	 * 
	 * - bg			: url du fichier arrière plan
	 * - fg			: url du fichier premier plan
	 * - swf			: url du fichier swf conteneur. si un mc vimeoContainer le player
	 * 				  est injecté dedans. Peut contenir un bouton "quitter" : mc closeButton
	 * - tile 		: id du tile dans lequel le player est injecté 						// TODO
	 * - x			: coordonnée x du swf, bg et fg si il y à
	 * - y			: coordonnée y du swf, bg et fg si il y à
	 * - pam			: "pause ambient music" met la zique ambiante (AudioHelper)	en pause
	 * - fz			: "freeze scène" freeze la scène											// TODO
	 * - sl			: "show loading" ? grise la scène et affiche un loader initiale (pendant chargement
	 * 					assets + player)
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class VimeoPlayerTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------

		public static const CLASS_ID:int = 102;
		
		public static const ALBUM:String = "album";
		public static const VIDEO:String = "video";
		
		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------
		
		// bulkloader
		private var loader:BulkLoader;
		// plaer Viméo
		private var player:VimeoPlayer;
		// type de media que le lecteur va lire, album ou video
		private var _mediaType:String;
		// swf conteneur
		private var swf:MovieClip;
		// swf / bitmap d'arrière plan
		private var bg:DisplayObject;
		// swf / bitmap d'avant plan
		private var fg:DisplayObject;
	
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Retourne le type de media consulté, album ou vidéo
		 */
		public function get mediaType () : String
		{
			return _mediaType;
		}
		
		/**
		 * Retourne l'identifiant du média consulté (pas la vidéo en cours d'affichage)
		 */
		public function get mediaId () : String
		{
			return mediaType == ALBUM ? getPropertie("al").id : getPropertie("vid").id;
		}
		
		/**
		 * @private
		 * Ref AudioHelper
		 */
		public function get audioHelper () : AudioHelper
		{
			return AudioHelper(facade.getObserver(AudioHelper.NAME));
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function execute (e:Event = null) : void
		{
			// check des arguments 		
			if (isPropertie("al"))
			{
				// > on veut un album
				_mediaType = ALBUM;
			}
			else if (isPropertie("vid"))
			{
				// > on veut une vidéo seule
				_mediaType = VIDEO;
			}
			
			if (mediaType)
			{
				// coupure fond sonore scène
				if (getPropertie("pam")) audioHelper.pauseMusic();
				
				// mise en place du player
				if (!loadAssets()) fire();
			}
			else
			{
				super.complete();
			}
		}
		
		
		//---------------------------------------
		// EVENT HANDLERS
		//---------------------------------------
		
		/**
		 * Réception player prêt
		 *	@param event Event
		 */
		private function handlePlayerInit (event:Event) : void
		{
			// TODO
		}
		
		/**
		 * Réception chargement assets
		 *	@param event Event
		 */
		private function handleLoader (event:Event) : void
		{
			// TODO handle des erreurs
			loader.removeEventListener(Event.COMPLETE, handleLoader);
			
			switch (event.type)
			{
				case Event.COMPLETE :
				{
					if (isPropertie("swf"))
						swf = loader.getMovieClip(getPropertie("swf"), true);
					if (isPropertie("bg"))
						bg = loader.getDisplayObjectLoader(getPropertie("bg"), true);
					if (isPropertie("fg"))
						bg = loader.getDisplayObjectLoader(getPropertie("bg"), true);
						
					fire();
					break;
				}
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * Charge les ressources
		 *	@private
		 *	@return Boolean
		 */
		private function loadAssets () : Boolean
		{
			loader = BulkLoader.getLoader("vimeo");
			if (!loader) loader = new BulkLoader("vimeo");
						
			var ass:Array = [];
			if (isPropertie("swf")) ass.push(getPropertie("swf"));
			if (isPropertie("bg")) ass.push(getPropertie("bg"));
			if (isPropertie("fg")) ass.push(getPropertie("fg"));
			
			if (ass.length > 0)
			{
				for each (var s:String in ass)
					loader.add(s, {preventCache:true});
				
				loader.addEventListener(Event.COMPLETE, handleLoader);
				loader.start();
				
				return true;
			}
			
			return false;
		}
		
		/**
		 *	@private
		 * Mise en place du player Viméo
		 * selon les arguments passés au trigger
		 */
		private function fire () : void
		{
			player = new VimeoPlayer();
			
			var da:Rectangle = UIHelper.VIEWPORT_AREA;	// "displayArea"
			// init placement et taille du player
			var plc:Object;
			if (isPropertie("pl"))
			{
				plc = getPropertie("pl");			// "playerConfig"
				if (plc.hasOwnProperty("x")) player.x = plc.x;
				if (plc.hasOwnProperty("y")) player.y = plc.y;
				if (plc.hasOwnProperty("w")) player.width = plc.w;
				if (plc.hasOwnProperty("h")) player.height = plc.h;
				if (plc.hasOwnProperty("c")) player.color = plc.c;
			}
			
			// coordonnées placement swf, arrière plan, avant plan
			var ax:int = isPropertie("x") ? da.x + getPropertie("x") : da.x;
			var ay:int = isPropertie("y") ? da.y + getPropertie("y") : da.y;

			// > arrière plan
			if (bg)
			{
				bg.x = ax;
				bg.y = ay;
				stage.addChild(bg);
			}
			
			// > swf
			if (swf)
			{
				// injection dans swf
				if (swf.hasOwnProperty("vimeoContainer"))
				{
					// check si on reflete les dimensions du conteneur au player
					var fw:int = 0;
					var fh:int = 0;
					if (plc)
					{
						if (plc.hasOwnProperty("w")) fw = getPropertie("w");
						if (plc.hasOwnProperty("h")) fw = getPropertie("h");
					}
					if (fw < 10) player.width = swf.vimeoContainer.width;
					if (fh < 10) player.height = swf.vimeoContainer.height;
				
					swf.vimeoContainer.addChild(player);
				}
				else
				{
					swf.addChild(player);
				}
				
				// bouton quitter
				if (swf.hasOwnProperty("closeButton"))
				{
					swf.closeButton.addEventListener(MouseEvent.MOUSE_UP, complete);
				}
				
				swf.x = ax;
				swf.y = ay;
				stage.addChild(swf);
			}
			else
			{
				player.x += da.x;
				player.y += da.y;
				stage.addChild(player);
			}
			
			if (fg)
			{
				fg.x = ax;
				fg.y = ay;
				stage.addChild(fg);
			}
			
			// chargemenent selon media
			switch (mediaType)
			{
				case ALBUM :
				{
					player.loadAlbum(getPropertie("al").id, getPropertie("al"));
					break;
				}
				case VIDEO :
				{
					// TODO
					break;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function complete (event:Event = null) : void
		{
			if (player)
			{
				player.unLoad();
				if (bg) stage.removeChild(bg);
				if (fg) stage.removeChild(fg);
				if (swf)
				{
					if (swf.hasOwnProperty("closeButton")) {
						swf.removeEventListener(MouseEvent.MOUSE_UP, complete);
					}
					stage.removeChild(swf);
				}
			}
			// reprise lecture musique ambiante
			if (getPropertie("pam")) audioHelper.resumeMusic();

			super.complete(event);
		}
			
	}

}
