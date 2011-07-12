/* ---------- Moogaloop API ----------------

Functions

These are the functions that you can call to control Moogaloop or get data from it. All functions are prepended with "api_" to avoid Flash keyword conflicts.

api_changeColor(color):void	Change the color of the player to the specified hex value (without the #).
api_getCurrentTime():int		Get the elapsed time in seconds.
api_getDuration():int			Get the length of the video in seconds.
api_pause():void					Pause the currently playing video.
api_play():void					Play the video.
api_seekTo(seconds):void		Seeks to the specified time in the video (in seconds).
api_setLoop(loop):void			Turn looping on or off (0 or 1).
api_setVolume(level):void		Change volume of the player (0-100).
api_unload():void					Stop downloading the video.

Events

You can listen for these events by calling api_addEventListener.

onFinish 		Fired when the video has finished playing.
onLoading 		Fires while the video is loading. Returns bytes loaded, and the percentage loaded.
onProgress 		Fires while the video is playing. Returns the number of seconds played.
onPlay 			Fires when user clicks play.
onPause 			Fires when user clicks pause.
onSeek 			Fires while the user is seeking through the video. Returns the position in seconds.

--------------------------------------------- */
/* --------- descrybType Moogaloop -------------

-- Méthodes --

<method name="api_isPlaying" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="Boolean"/>
<method name="onScreenShow" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="*" optional="false"/>
</method>
<method name="api_setOnPauseCallback" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="String" optional="false"/>
</method>
<method name="onFullscreenBeforeToggle" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="*" optional="false"/>
</method>
<method name="api_setLoop" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="*" optional="false"/>
</method>
<method name="api_likeClip" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void"/>
<method name="onShowOutroScreen" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void"/>
<method name="api_setVolume" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="*" optional="false"/>
</method>
<method name="api_setOnPlayCallback" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="String" optional="false"/>
</method>
<method name="api_isLoaded" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="Boolean"/>
<method name="loadXML" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="String" optional="true"/>
</method>
<method name="api_unload_other_players" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="*"/>
<method name="onPlayToggle" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void"/>
<method name="setPreference" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="*" optional="false"/>
</method>
<method name="api_onLoad" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void"/>
<method name="likeVideo" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="int" optional="false"/>
</method>
<method name="api_addEventListener" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="String" optional="false"/>
	<parameter index="2" type="String" optional="false"/>
</method>
<method name="onFullscreenToggle" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="*" optional="false"/>
</method>
<method name="onSeek" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="Number" optional="false"/>
</method>
<method name="api_togglePlayPause" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="Boolean" optional="false"/>
</method>
<method name="api_toggleLoop" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void"/>
<method name="api_disableHDEmbed" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="*"/>
<method name="api_setProgressCallback" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="String" optional="false"/>
</method>
<method name="api_enableHDEmbed" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="*"/>
<method name="mouseMove" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="flash.events::MouseEvent" optional="false"/>
</method>
<method name="api_getCurrentTime" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="Number"/>
<method name="mouseOut" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="flash.events::Event" optional="true"/>
</method>
<method name="onStreamLoading" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="Object" optional="true"/>
</method>
<method name="onShowLikeScreen" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void"/>
<method name="disableMouseMove" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void"/>
<method name="onShowEmbedScreen" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void"/>
<method name="api_play" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="*"/>
<method name="onShowShareScreen" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void"/>
<method name="onStreamNearFinish" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="Object" optional="true"/>
</method>
<method name="api_getDuration" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="Number"/>
<method name="api_changeColor" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="*">
	<parameter index="1" type="*" optional="false"/>
</method>
<method name="api_seekTo" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="*" optional="false"/>
</method>
<method name="api_loadVideo" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="int" optional="false"/>
</method>
<method name="api_setOnFinishCallback" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="String" optional="false"/>
</method>
<method name="onTinymodeToggle" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="Boolean" optional="false"/>
</method>
<method name="api_setSize" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="int" optional="false"/>
	<parameter index="2" type="int" optional="false"/>
</method>
<method name="api_pause" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="*"/>
<method name="toggleElement" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="String" optional="false"/>
	<parameter index="2" type="*" optional="true"/>
</method>
<method name="api_isPaused" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="Boolean"/>
<method name="api_toggleElement" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="*">
	<parameter index="1" type="String" optional="false"/>
	<parameter index="2" type="*" optional="true"/>
</method>
<method name="api_changeOutro" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="String" optional="false"/>
	<parameter index="2" type="*" optional="true"/>
</method>
<method name="onShowHDScreen" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void"/>
<method name="onStreamProgress" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="Object" optional="true"/>
</method>
<method name="redraw" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void"/>
<method name="onScrubStart" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void"/>
<method name="onAddedToStage" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="flash.events::Event" optional="true"/>
</method>
<method name="onStreamPlay" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="Object" optional="false"/>
</method>
<method name="api_toggleFullscreen" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void"/>
<method name="onStreamFinish" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void">
	<parameter index="1" type="Object" optional="true"/>
</method>
<method name="api_unload" declaredBy="com.as3.moogaloop4::Moogaloop" returnType="void"/>

-- Variables --
<variable name="parts" type="Array"/>
<variable name="player_loaded" type="Boolean"/>

-- Accesseurs --
<accessor name="soundTransform" access="readwrite" type="flash.media::SoundTransform" declaredBy="flash.display::Sprite"/>
--------------------------------------------- */

package com.sos21.media {
	
	import flash.system.Security;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import com.adobe.serialization.json.JSON;
	import br.com.stimuli.loading.BulkLoader;
	
	/**
	 *	Player vidéo Viméo étendu pour les besoins sos
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class VimeoPlayer extends Sprite {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const ALBUM_DESCRIPTION:int = 0;
		public static const VIDEO_DESCRIPTION:int = 1;
		public static const PLAYLIST:int = 2;
		public static const MOOGALOOP:int = 3;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function VimeoPlayer (opts:Object = null)
		{
			loader = BulkLoader.getLoader("vimeo");
			if (!loader) loader = new BulkLoader("vimeo");
//			loadMoogaloop();
			addEventListener(MouseEvent.MOUSE_OVER, handleScreen);
			addEventListener(MouseEvent.MOUSE_UP, handleScreen);
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		// loader
		protected var loader:BulkLoader;
		// api viméo (player)
		protected var moogaloop:Object;
		// couleur du player
		private var _pcol:uint = 0x00ADEF;
		// dimensions
		protected var _bounds:Rectangle = new Rectangle(0, 0, 400, 300);
		// options de l'album
		protected var _alOtps:Object;
		// dexcripteur album
		protected var _alDescriptor:Object;
		// options de la vidéo
		protected var _viOpts:Object;
		// video en cours
		protected var _currentVideo:String;
		// état en cours
		protected var _state:int;
		// écran affiché (par dessus le player)
		protected var _screen:Object;
		// état en lecture
		protected var _playing:Boolean = false;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------		
				
		/**
		 * Couleur du player (thème coloré gui)
		 */
		public function get color () : uint
		{
			return _pcol;
		}		
		
		public function set color (val:uint) : void
		{
			if (moogaloop)
			{
				moogaloop.api_changeColor(val.toString(16));
			}
			_pcol = val;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get width () : Number
		{
			return _bounds.width;
		}

		override public function set width (val:Number) : void
		{
			_bounds.width = int(val);

			if (moogaloop)
			{
				moogaloop.api_setSize(_bounds.width, _bounds.height);
			}
			
			scrollRect = _bounds;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get height () : Number
		{
			return _bounds.height;
		}
		
		override public function set height (val:Number) : void
		{
			_bounds.height = int(val);

			if (moogaloop)
			{
				moogaloop.api_setSize(_bounds.width, _bounds.height);
			}
			
			scrollRect = _bounds;
		}
		
		/**
		 * Retourne l'état en lecture du player
		 */
		public function get isPlaying () : Boolean
		{
			if (moogaloop)
			{
				if (moogaloop.player_loaded)
					return moogaloop.api_isPlaying();
			}
			
			return false;	
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Charge une vidéo
		 * @param	id	 identifiant de la vidéo
		 */
		public function loadVideo (id:String, opts:Object = null) : void
		{
			if (!moogaloop) return;
			
			moogaloop.api_loadVideo(id);
			_currentVideo = id;
			_viOpts = opts;
		}
		
		/**
		 *	..
		 */
		public function unLoad () : void
		{
			if (!moogaloop) return;

			moogaloop.api_unload();
		}
		
		/**
		 * Charge un album
		 *	@param id identifiant de l'album
		 * @param	opts	 options de l'album :
		 * 	- sds		: "show descrition at start" affiche la descrition de l'album au premier affichage
		 * 	- svls	: "show video list at start" affiche la liste des vidéos au premier affichage
		 * 	- asid	: "autostart" id de la vidéo à démarrer automatiquement
		 */
		public function loadAlbum (id:String, opts:Object = null) : void
		{
			_alOtps = opts;
			Security.loadPolicyFile("http://vimeo.com/api/crossdomain.xml");
			//http://vimeo.com/moogaloop/crossdomain.xml
			loader.add("http://vimeo.com/api/v2/album/" + id + "/info.json", {id:"al_info", preventCache:true});
			// data des videos de l'album
			loader.add("http://vimeo.com/api/v2/album/" + id + "/videos.json", {id:"al_videos", preventCache:true});

			loader.addEventListener(Event.COMPLETE, handleAlbumLoader);
			loader.start();
		}
		
		/**
		 *	// TODO documenter
		 */
		public function showAlbumScreen () : void
		{
			if (_alDescriptor)
			{
				if (isPlaying) moogaloop.api_pause();
				
				_screen = new AlbumScreen(_alDescriptor.title, _alDescriptor.description, width, height);
				addChild(_screen as Sprite);
				
				_state = ALBUM_DESCRIPTION;
			}
		}
		
		/**
		 *	// TODO documenter
		 */
		public function showPlayList () : void
		{
			if (_alDescriptor)
			{
				if (isPlaying) moogaloop.api_pause();

				// largeur des vignettes aperçu
				var thWidth:int = width / 3;
				_screen = new PlaylistScreen(_alDescriptor.videos, width, height, thWidth, _pcol);
				_screen.addEventListener(Event.SELECT, handleScreen);
				
				addChild(_screen as Sprite);
				
				// scroll à la vidéo en cours
				_screen.scrollToItem(_currentVideo)
								
				_state = PLAYLIST;
			}
		}
		
		// @ --- accès api Moogaloop ---
		
		/**
		 *	Joue la vidéo
		 */
		public function play () : void
		{
			moogaloop.api_play();
		}
		
		/**
		 *	Met en pause la vidéo
		 */
		public function pause () : void
		{
			moogaloop.api_pause();
		}
		
		/**
		 * Retourne la durée de la vidéo
		 */
		public function getDuration () : int
		{
			return moogaloop.api_getDuration();
		}
		
		/**
		 * Seek to specific loaded time in video (in seconds)
		 */
		public function seekTo (time:int) : void
		{
			moogaloop.api_seekTo(time);
		}
		
		// ---- @
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		/**
		 * Réception des events souris
		 *	@param event MouseEvent
		 */
		protected function handleScreen (event:Event) : void
		{
			switch (_state)
			{
				case ALBUM_DESCRIPTION :
				{
					if (event.type == MouseEvent.MOUSE_UP)
					{
						removeChild(_screen as Sprite);
						_screen = null;
						if (_alOtps)
						{
							// option affichage de la playlist au démarage
							if (_alOtps.svls)
							{
								showPlayList();
							}
						}
					}						
					break;
				}
				case VIDEO_DESCRIPTION :
				{
					
					break;
				}
				case PLAYLIST :
				{
					if (event.type == Event.SELECT)
					{
						// identifiant de la vidéo cliquée
						var svid:String = _alDescriptor.videos[_screen.scrollIndex].id;
						if (_currentVideo != svid)
						{
							loadVideo(svid);
						}
						
						_screen.removeEventListener(Event.SELECT, handleScreen);
						removeChild(_screen as Sprite);
						_screen = null;
					}
					break;
				}
				case MOOGALOOP :
				{
					
					break;
				}
			}
		}
		
		protected function handle (e:Event) : void
		{
			var ip:Boolean = isPlaying;
			if (_playing != ip)
			{
				if (!ip) showPlayList();
				_playing = ip;
			}
		}
		
		/**
		 * Réception chargement album
		 *	@param event Event
		 */
		protected function handleAlbumLoader (event:Event) : void
		{
			/*trace("info", this, "ALBUM ---");
			trace(loader.getText("al_info"));
			trace("info", this, "VIDEOS ---");
			trace(loader.getText("al_videos"));
			trace(loader.getContent("al_videos"));
			return;*/
			
			switch (event.type)
			{
				case Event.COMPLETE :
				{
					event.target.removeEventListener(Event.COMPLETE, handleAlbumLoader);
					
					// recup du descripteur
					_alDescriptor = JSON.decode(loader.getText("al_info", true));
					_alDescriptor.videos = JSON.decode(loader.getText("al_videos", true));
					
					// affichage info album
					if (_alOtps)
					{
						var sds:Boolean;
						var svls:Boolean;
						
						if (_alOtps.hasOwnProperty("sds"))
						{
							sds = _alOtps.sds;
						}
						
						if (_alOtps.hasOwnProperty("svls"))
						{
							svls = _alOtps.svls;
						}
						
						if (sds)
						{
							displayAlbum();
						}
						else if (svls)
						{
							showPlayList();
						}							
					}					
					
					// chargement première vidéo
					// TODO chargement vidéo ciblée depuis _alOtps
					if (moogaloop)
					{
						loadVideo(_alDescriptor.videos[0].id);
					} else {
						loadMoogaloop(_alDescriptor.videos[0].id);
					}
					break;
				}
			}
		}
		
		/**
		 * Réception chargement et init api moogaloop
		 *	@param event Event
		 */
		protected function handleMoogaloopLoader (event:Event) : void
		{
			switch (event.type)
			{
				// > chargement api
				case Event.COMPLETE :
				{
					event.target.removeEventListener(Event.COMPLETE, handleMoogaloopLoader);
					
					moogaloop = loader.getContent("moogaloop", true);
					addChildAt(moogaloop as DisplayObject, 0);
					
					// écoute initialisation moogaloop
					addEventListener(Event.ENTER_FRAME, handleMoogaloopLoader);
					break;
				}
				// > init moogaloop
				case Event.ENTER_FRAME :
				{
					if (moogaloop.player_loaded)
					{
						removeEventListener(Event.ENTER_FRAME, handleMoogaloopLoader);
						
						width = _bounds.width;
						height = _bounds.height;
						color = _pcol;
						
						dispatchEvent(new Event(Event.INIT));
						
						moogaloop.addEventListener(MouseEvent.CLICK, captureMoogaMouse, true);
						// écoute pour les events pause / play
						addEventListener(Event.ENTER_FRAME, handle);
					}
					break;
				}
			}
		} 
		
		public function captureMoogaMouse (e:Event) : void
		{
			trace(this, e.target.parent);
//			e.stopImmediatePropagation();	
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function displayAlbum () : void
		{
			if (_alOtps)
			{
				switch (true)
				{
					// descrition au premier affichage
					case _alOtps.hasOwnProperty("sds") :
					{
						showAlbumScreen();				
						break;
					}
					// liste des vidéos au premier affichage
					case _alOtps.hasOwnProperty("svls") :
					{
						
						break;
					}
				}				
			}
		}
		
		/**
		 *	@private
		 * Charge l'api moogaloop
		 * @param	vid	 identifiant de la vidéo à charger
		 */
		protected function loadMoogaloop (vid:String = null) : void
		{
			Security.allowDomain("*");
			Security.loadPolicyFile("http://vimeo.com/moogaloop/crossdomain.xml");
			
			var bu:String = "http://api.vimeo.com/moogaloop_api.swf?oauth_key=12a4aa902e57017a9774d077b89f6100";
			bu += "&fullscreen=0";
			if (vid)
			{
				bu += "&clip_id=" + vid;
			}
			loader.add(bu, {id:"moogaloop", preventCache:true});
			loader.addEventListener(Event.COMPLETE, handleMoogaloopLoader);
			loader.start();
		}
	}

}

	
	// ----------
	
	import flash.geom.*;
	import flash.events.*;
	import flash.text.*;
	import flash.display.*;
	import flash.net.URLRequest;
	import gs.TweenMax;
	import gs.easing.*;
	
	/**
	 * Ecran Playlist sauce Viméo like
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author toffer
	 */
	internal class PlaylistScreen extends Sprite {
	
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
	
		public function PlaylistScreen (videos:Array, w:int, h:int, thw:int = 200, col:uint = 0x00ADEF)
		{
			_videos = videos;
			_w = w;
			_h = h;
			_thw = thw;
			_col = col;
			drawBackground();
			drawItems();
			drawForeground();
			drawButtons();
			scrollIndex = 0;
			
			addEventListener(MouseEvent.MOUSE_UP, handleButtonEvent);
			itemSprite.addEventListener(MouseEvent.MOUSE_OVER, handleItemEvent);
			itemSprite.addEventListener(MouseEvent.MOUSE_OUT, handleItemEvent);
			itemSprite.addEventListener(MouseEvent.MOUSE_UP, handleItemEvent);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
	
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
	
		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------
	
		// liste des vidéos (descripteurs)
		private var _videos:Array;
		// liste des éléments affichés (PlaylistItem)
		private var _items:Array;
		// marges interieurs (guache, droite, haut et bas)
		private var _padding:int = 20;
		// espacement entre les items
		private var _vgap:int = 10;
		// largeur
		private var _w:int;
		// hauteur
		private var _h:int;
		// largeur de la vignette image
		private var _thw:int;
		// couleur maîtresse
		private var _col:uint;
		// boutons scrolling
		private var buttonUp:SimpleButton;
		private var buttonDown:SimpleButton;
		// bouton lecture
		private var playButton:SimpleButton;
		// conteneur items
		private var itemSprite:Sprite;
		// index de scrolling
		private var _scInd:int = 10000;
	
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
	
		/**
		 * @inheritDoc
		 */
		override public function set width (val:Number) : void
		{
			if (_items)
			{
				var w:int =  _w - (_padding * 2);
				for each (var i:Object in _items)
					i.width = w;
			}
			_w = val;
		}
	
		/**
		 * Index de scrolling
		 */
		public function get scrollIndex () : int
		{
			return _scInd;
		}
	
		public function set scrollIndex (val:int) : void
		{
			var l:int = _items.length;
			if (val == _scInd || val < 0 || val == l || l == 0) return;
		
			// calcul de la nouvelle position	
			var ith:int = _items[0].height;
			var ofs:int = (_h / 2) - ((val * (ith + _vgap)) + (_items[val].height / 2));
			// animation
			TweenMax.to(itemSprite, 0.7, {y:ofs, ease:Strong.easeOut});
		
			_scInd = val;
			
			// boutons scroll
			buttonUp.enabled = _scInd == 0 ? false : true;
			buttonDown.enabled = _scInd == l -1 ? false : true;
			
			dispatchEvent(new Event(Event.SCROLL));
		}
	
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Scroll jusqu'à la vidéo
		 *	@param id String identifiant de la vidéo
		 */
		public function scrollToItem (id:String) : void
		{
			var n:int = _videos.length;
			for (var i:int = 0; i < n; i++)
			{
				if (_videos[i].id == id)
				{
					scrollIndex = i;
					break;
				}
			}
		}
		
		//---------------------------------------
		// EVENT HANDLERS
		//---------------------------------------
	
		/**
		 * Réception events des boutons
		 *	@param event Event
		 */
		protected function handleButtonEvent (event:Event) : void
		{
			switch (event.target)
			{
				case buttonUp :
				{
					scrollIndex--;		
					break;
				}
			
				case buttonDown :
				{
					scrollIndex++;
					break;
				}
			}
		}
		
		/**
		 * Réception events des items
		 *	@param event MouseEvent
		 */
		protected function handleItemEvent (event:MouseEvent) : void
		{			
			var it:Object = event.target;
			var ind:int = _items.indexOf(it);

			if (ind < 0) return;
			
			switch (event.type)
			{
				case MouseEvent.MOUSE_OVER :
				{
					if (_scInd == ind)
					{
						it.border = 6;
					}
					break;
				}
				case MouseEvent.MOUSE_OUT :
				{
					if (_scInd == ind)
					{
						it.border = 0;
					}					
					break;
				}
				case MouseEvent.MOUSE_UP :
				{
					dispatchEvent(new Event(Event.SELECT));
					break;
				}
			}
		}
		
		/**
		 *	@param event Event
		 */
		protected function destroy (event:Event) : void
		{
			removeEventListener(MouseEvent.MOUSE_UP, handleButtonEvent);
			itemSprite.removeEventListener(MouseEvent.MOUSE_OVER, handleItemEvent);
			itemSprite.removeEventListener(MouseEvent.MOUSE_OUT, handleItemEvent);
			itemSprite.removeEventListener(MouseEvent.MOUSE_UP, handleItemEvent);
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		//---------------------------------------
		// PRIVATE & PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * Ajoute les boutons nav
		 *	@private
		 */
		protected function drawButtons () : void
		{
			// boutons scrolling
			buttonUp = new PlaylistUpButton(_col);
			buttonDown = new PlaylistDownButton(_col);
			var bth:int = buttonUp.height;
			buttonDown.y = height - _padding - bth;
			buttonUp.y = buttonDown.y - bth - 2;
			var mid:int = (width - buttonUp.width) / 2;
			buttonDown.x = buttonUp.x = mid;

			// bouton lecture
//			playButton = new PlayButton(_col);
//			playButton.x = (mid - playButton.width) / 2;
//			playButton.y = height - _padding - playButton.height;

			addChild(buttonUp);
			addChild(buttonDown);
//			addChild(playButton);
		}
		
		/**
		 * Ajoute la liste des vidéos (vignette + desc)
		 *	@private
		 */
		protected function drawItems () : void
		{
			itemSprite = new Sprite();
			_items = [];
			var w:int =  _w - (_padding * 2);
			var ofs:int = 0;
			var l:Loader;
			var it:PlaylistItem;
			for each (var v:Object in _videos)
			{
				it  = new PlaylistItem(v.thumbnail_medium, v.title, v.description, _thw, _col);
				it.width = w;
				it.y = ofs;
				it.cacheAsBitmap = true;
				it.mouseChildren = false;
				it.buttonMode = true;
				ofs += it.height + _vgap;
				_items.push(it);
				itemSprite.addChild(it);
			}
		
			itemSprite.x = _padding;
			addChild(itemSprite);
		}
		
		/**
		 * Ajoute l'avant plan (sorte de masque en dégradé)
		 *	@private
		 */
		private function drawForeground () : void
		{
			var rect:Sprite = new Sprite();
			// calcul taille du dégradé haut et bas
			// ratio
			var r:Number = _h / 255;
			// marges haut / bas
			var m:Number = _h - _items[0].height - (_vgap * 2);
			var dh:int = (m / r) / 2;
			var g:int = _vgap / r;
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(_w, _h, 90 * Math.PI / 180);
			var colors:Array = [0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000];
			var alphas:Array = [1, .6, 0, 0, .6, 1];
			var ratios:Array = [0, dh, dh + g, 255 - dh - g, 255 - dh, 255];
			
			rect.graphics.lineStyle();
			rect.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, mat);
			rect.graphics.drawRect(0, 0, _w, _h);
			rect.graphics.endFill();
			
			rect.mouseEnabled = false;
			addChild(rect);
		}
		
		/**
		 * Ajoute l'arrière plan
		 *	@private
		 */
		private function drawBackground () : void
		{
			graphics.clear();
			graphics.beginFill(0x000000, 0.92);
			graphics.drawRect(0, 0, _w, _h);
			graphics.endFill();
		}
	
	}


	/**
	 * Bouton scrolling direction haute de la playlist
	 * dans le ton Viméo
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author toffer
	 */
	internal class PlaylistUpButton extends SimpleButton
	{
	
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------

		public function PlaylistUpButton (rcol:uint = 0x00ADEF, w:int = 100, h:int = 16, padTop:int = 3) : void
		{
			super();
			_w = w;
			_h = h;
			_padTop = padTop;
			_rcol = rcol;
			drawChildrens();
		}
	
		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------
	
		// marge intérieur haute (pour la flèche)
		protected var _padTop:int;
		// largeur / hauteur
		protected var _w:int;
		protected var _h:int;
		// coins arrondis
		protected var _cor:int = 4;
		// couleur roll over
		protected var _rcol:uint;
		
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function set enabled (val:Boolean) : void
		{
			super.enabled = val;
			alpha = val ? 1 : 0.3;
		}
			
		//---------------------------------------
		// PRIVATE & PROTECTED METHODS
		//---------------------------------------
		
		/**
		 *	Dessine le bouton
		 */
		protected function drawChildrens () : void
		{
			var sp:Sprite = new Sprite();
			var sh:Shape = bg(0x444444);
			sh.alpha = 0.7;
			sp.addChild(sh);
			sp.addChild(fg());
			upState = sp;
			sp = new Sprite();
			sp.addChild(bg(_rcol));
			sp.addChild(fg());
			overState = downState = hitTestState = sp;
		}
		
		/**
		 *	Retourne l'avant plan
		 *	@return Shape
		 */
		protected function fg () : Shape
		{
			// calcul taille de la flèche
			var asi:int = _h - (2 * _padTop);
			
			var s:Shape = new Shape()
			s.graphics.beginFill(0xFFFFFF);
			var ph:int = (_w - asi) / 2; // padding horizontal
			var pv:int = (_h - asi) / 2; // padding vertical
			s.graphics.moveTo(ph, pv + asi);
			s.graphics.lineTo(_w / 2, pv);
			s.graphics.lineTo(ph + asi, pv + asi);
			s.graphics.endFill();
			return s;
		}
		
		/**
		 * Retourne l'arrère plan
		 *	@param col uint couleur
		 *	@return Shape
		 */
		protected function bg (col:uint) : Shape
		{
			var s:Shape = new Shape();
			s.graphics.beginFill(col);
			s.graphics.drawRoundRect(0, 0, _w, _h, _cor, _cor);
			s.graphics.endFill();
			return s;
		}
	
	}


	/**
	 * Bouton scrolling de la playlist direction bas
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author toffer
	 */
	internal class PlaylistDownButton extends PlaylistUpButton {
	
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
	
		public function PlaylistDownButton (rcol:uint = 0x00ADEF, w:int = 100, h:int = 16, padTop:int = 3) : void
		{
			super(rcol, w, h, padTop);
		}
	
		//---------------------------------------
		// PRIVATE & PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function fg () : Shape
		{
			// calcul taille de la flèche
			var asi:int = _h - (2 * _padTop);
			
			var s:Shape = new Shape()
			s.graphics.beginFill(0xFFFFFF);
			var ph:int = (_w - asi) / 2; // padding horizontal
			var pv:int = (_h - asi) / 2; // padding vertical
			s.graphics.moveTo(ph, pv);		
			s.graphics.lineTo(ph + asi, pv);
			s.graphics.lineTo(_w / 2, pv + asi);
			s.graphics.endFill();
			return s;
		}
	
	}
	
	
	/**
	 * Sprite vignette + descriptif pour la playlist
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author toffer
	 */
	internal class PlaylistItem extends Sprite {
	
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
	
		public function PlaylistItem (thumb:String, title:String, body:String, thw:int, col:uint = 0x00ADEF)
		{
			_title = title;
			_body = body;
			_thw = thw;
			_col = col;
			_l = new Loader();
			_l.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoader);
			_l.load(new URLRequest(thumb));
		}
	
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
	
		public static var textFormat:TextFormat = new TextFormat("Verdana", 10, 0xFFFFFF);
	
		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------
	
		protected var _title:String;
		protected var _body:String;
		protected var _l:Loader;
		protected var _t:TextField;
		protected var _w:int;
		protected var _thw:int;
		// ratio largeur / hauteur vignette
		protected var _thr:Number = 1 / 0.75;
		// couleur maîtresse
		protected var _col:uint;
	
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		public function get border () : int
		{
			return 1;
		}
		
		public function set border (val:int) : void
		{
			graphics.clear();
			if (val > 0)
			{
				graphics.lineStyle(val, _col);
				var ofs:int = val / 2;
				graphics.drawRect(-ofs, -ofs, _w + val, height + val);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width (val:Number) : void
		{
			if (_t && _l)
			{
				var ofs:int = _l.width + 10;
				_t.x = ofs;
				_t.width = val - ofs;
			}
			_w = val;
		}
	
		override public function get height () : Number
		{
			return int(_thw / _thr);
		}
	
		//---------------------------------------
		// EVENT HANDLERS
		//---------------------------------------
	
		/**
		 * Réception chargement loader de la vignette apreçu
		 *	@param event Event
		 */
		private function handleLoader (event:Event) : void
		{
			switch (event.type)
			{
				case Event.COMPLETE :
				{
					_l.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleLoader);
					addChildrens();
					break;
				}
			}
		}
	
		//---------------------------------------
		// PRIVATE & PROTECTED METHODS
		//---------------------------------------
	
		protected function addChildrens () : void
		{
			_t = new TextField();
			_t.defaultTextFormat = textFormat;
			_t.height = height;
			_t.selectable = false;
			_t.multiline = true;
			_t.wordWrap = true;
			_t.htmlText = "<b>" + _title + "</b>";
			_t.htmlText += '<p align="justify">' + _body.replace(/(\r|\n)/gm, "") + '</p>';
			
			_l.width = _thw;
			_l.height = height;
			
			addChild(_l);
			addChild(_t);
		
			width = _w;
		}
	
	}
	
	
	/**
	 * Ecran descriptif d'un album
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author toffer
	 */
	internal class AlbumScreen extends Sprite {
	
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
	
		public function AlbumScreen (title:String, body:String, w:int, h:int)
		{
			super();
			_title = title;
			_body = body;
			setSize(w, h);
		}
	
		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------
	
		private var _title:String;
		private var _body:String;
		private var _mtf:TextField;
		private var _itf:TextField;
		private var _w:int;
		private var _h:int;
		private var _padding:int = 20;
	
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
	
		public function setSize (w:int, h:int) : void
		{
			_w = w;
			_h = h;
			drawBackground();
			drawTextField();
		}
	
		//---------------------------------------
		// PRIVATE VARIABLES
		//---------------------------------------
	
		private function drawTextField () : void
		{
			if (!_mtf)
			{
				// champ texte principal
				_mtf = new TextField();
				_mtf.selectable = false;
				_mtf.wordWrap = true;
				_mtf.multiline = true;
				_mtf.autoSize = TextFieldAutoSize.CENTER;
				var tf:TextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
				_mtf.defaultTextFormat = tf;
				_mtf.htmlText = '<p align="center">' + _title + '</p><br><p align="justify">' + _body + '</p>';
				addChild(_mtf);
				// champ text info
				_itf = new TextField();
				_itf.selectable = false;
				_itf.autoSize = TextFieldAutoSize.CENTER;
				tf.size = 10;
				_itf.defaultTextFormat = tf;
				_itf.text = "... cliquez pour accéder au vidéos ...";
				addChild(_itf);
			}
				
			_mtf.x = _itf.x = _mtf.y = _padding;
			_itf.y = _h - _itf.height - _padding;
			_mtf.width = _itf.width = _w - (_padding * 2);
		}
	
		private function drawBackground () : void
		{
			graphics.clear();
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, _w, _h);
			graphics.endFill();
		}
	
	}
