package ddgame.triggers {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import gs.TweenLite;
	import caurina.transitions.Equations;
	import com.sos21.debug.log;
	import ddgame.triggers.AbstractTrigger;
	import ddgame.scene.IsosceneHelper;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class VideoPlayerTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 8;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		[Embed(source='../../../assets/videoPlayerControls.swf', symbol='SimpleControls')]
		private var videoControlsClass:Class;
		
		private var videoControls:MovieClip;
		private var player:Object;			// player video (dans le backgroundLayer)
		private var mcSource:Object;
		private var targetBounds:Object;	// aire du tile pour test over / out
		
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		override public function execute(event:Event = null):void
		{
			// on recupe le player video
			var cont:Object = Loader(IsosceneHelper(facade.getObserver(IsosceneHelper.NAME)).component.backgroundLayer.getChildAt(0)).content;
			player = cont.player;			
			
			// on recale les effets du tile et on prend la main dessus
			sourceTarget.filters = [];
			sourceTarget.mouseEnabled = true;
			sourceTarget.mouseChildren = true;
			sourceTarget.buttonMode = false;
			
			// on cible la vue du tile pour prendre le controle avec les listener souris
/*			mcSource = Loader(sourceTarget.getView().getChildAt(0)).content;			
			mcSource.projo.addEventListener(MouseEvent.MOUSE_OVER, sourceTargetMouseHandler, false, 100);
			mcSource.projo.addEventListener(MouseEvent.MOUSE_OUT, sourceTargetMouseHandler, false, 100);
			mcSource.projo.addEventListener(MouseEvent.CLICK, sourceTargetMouseHandler, false, 100);
			
			targetBounds = mcSource.projo.getBounds(stage); */
			
			// on cible la vue du tile pour prendre le controle avec les listener souris
			mcSource = Loader(sourceTarget.getChildAt(0)).content;
			mcSource.addEventListener(MouseEvent.MOUSE_OVER, sourceTargetMouseHandler, false, 100);
			mcSource.addEventListener(MouseEvent.MOUSE_OUT, sourceTargetMouseHandler, false, 100);
			mcSource.addEventListener(MouseEvent.CLICK, sourceTargetMouseHandler, false, 100);
			//player.loaderListXmlData();
			targetBounds = mcSource.getBounds(stage);
			
			mcSource.gotoAndStop("fx");
			
			// les controles "osd" pour piloter les videos
			videoControls = new videoControlsClass() as MovieClip;
			// patch
			videoControls.playPauseBtn.gotoAndStop(1);
			videoControls.soundPauseBtn.gotoAndStop(1);
			player.unmuteClicked();
			videoControls.buttonMode = true;
			videoControls.playItemDownBtn.visible = false;
			videoControls.playItemUpBtn.visible = false;
			// Gestion du son
			/*var tmpVolume:int = 2;
			trace("Vol " + tmpVolume);
			if(player.shoVideoPlayerSettings.data.playerVolume != undefined) {
				player.tmpVolume = player.shoVideoPlayerSettings.data.playerVolume;
				player.intLastVolume = tmpVolume;
			}
			player.setVolume(tmpVolume);
			// update volume bar and set volume
			videoControls.mcVolumeScrubber.x = (5.5 * tmpVolume) + 50;
			videoControls.mcVolumeFill.mcFillRed.width = videoControls.mcVolumeScrubber.x - 320 + 53;
			trace("Vol2 " + tmpVolume);
			*/
			
			
			addVideoControls();
			
			
			// on lance la première vidéo
			videoControls.playPauseBtn.gotoAndStop("pause");
			player.playClicked();
		}
		
		/**
		 *	Ajoute les controles "osd" videos
		 */
		public function addVideoControls():void
		{
			if (!stage.contains(videoControls)) {
				player.mcVideoControls.visible = true;
				videoControls.x = int(getPropertie("controlsX"));
				videoControls.y = int(getPropertie("controlsY"));
				stage.stage.addChild(videoControls);
			
				videoControls.addEventListener(MouseEvent.MOUSE_OVER, videoControlsMouseHandler);
				videoControls.addEventListener(MouseEvent.MOUSE_OUT, videoControlsMouseHandler);
				videoControls.addEventListener(MouseEvent.CLICK, videoControlsMouseHandler);
				videoControls.alpha = 0;
				TweenLite.to(videoControls, 0.6, {alpha:1});
			}
		}
		
		/**
		 *	Supprime les controles "osd" videos
		 */
		public function removeVideoControls():void
		{
			if (stage.contains(videoControls)) {
				videoControls.removeEventListener(MouseEvent.MOUSE_OVER, videoControlsMouseHandler);
				videoControls.removeEventListener(MouseEvent.MOUSE_OUT, videoControlsMouseHandler);
				videoControls.removeEventListener(MouseEvent.CLICK, videoControlsMouseHandler);
				stage.removeChild(videoControls);
				player.mcVideoControls.visible = false;
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	Manipulateur souris sur tile
		 *	Affiche / cache les controles "osd" videos
		 */
		private function sourceTargetMouseHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					addVideoControls();
					break;
				case MouseEvent.MOUSE_OUT :
					var mx:int = stage.mouseX;
					var my:int = stage.mouseY;
					if (mx < targetBounds.x || mx > targetBounds.x + targetBounds.width || mx < targetBounds.y || my > targetBounds.y + targetBounds.height)
						removeVideoControls();
					break;
				default :
					break;
			}
		}
		
		/**
		 *	Manipulateur souris sur les controles "osd" videos
		 */
		private function videoControlsMouseHandler(e:Event):void
		{
			var targ:Object = e.target;
			var typ:String = e.type;
			if (typ == MouseEvent.CLICK)
			{
				switch (targ)
				{
					case videoControls.playPauseBtn :
						if (videoControls.playPauseBtn.currentLabel == "pause") {
							videoControls.playPauseBtn.gotoAndStop("play");
							player.pauseClicked();
							
							
						} else {
							videoControls.playPauseBtn.gotoAndStop("pause");
							player.intVid = player.intActiveVid;
							player.playClicked();
							player.removeListXmlData();
							
						}		
						videoControls.playItemDownBtn.visible = false;
						videoControls.playItemUpBtn.visible = false;
						videoControls.playListBtn.visible = true;
						break;					
					case videoControls.prevVideoBtn :
						player.playPrevious();
						videoControls.playPauseBtn.gotoAndStop("pause");
						videoControls.playItemDownBtn.visible = false;
						videoControls.playItemUpBtn.visible = false;
						videoControls.playListBtn.visible = true;
						player.removeListXmlData();
						break;
					case videoControls.nextVideoBtn :
						player.playNext();
						videoControls.playPauseBtn.gotoAndStop("pause");
						videoControls.playItemDownBtn.visible = false;
						videoControls.playItemUpBtn.visible = false;
						videoControls.playListBtn.visible = true;
						player.removeListXmlData();
						break;
					case videoControls.playListBtn :
						//trace ("XML LIST" + player.child);
						player.displayListXmlData();
						//this.stage.addChildAt(player.listXml,0);
						videoControls.playItemDownBtn.visible = true;
						videoControls.playItemUpBtn.visible = true;
						videoControls.playListBtn.visible = false;
						//listXml.videoData1
						//videoControls.addChildAt(player.listXml,0 );
						videoControls.playPauseBtn.gotoAndStop("play");
						//player.pauseClicked();
						player.stopVideoPlayer();
						player.bolLoaded = false;
						
						break;
					case videoControls.turnOffBtn :
						videoControls.playItemDownBtn.visible = false;
						videoControls.playItemUpBtn.visible = false;
						videoControls.playListBtn.visible = true;
						player.removeListXmlData();
						complete();
						break;
					case videoControls.playItemDownBtn :
						player.movieNext();
						break;
					case videoControls.playItemUpBtn :
						player.moviePrevious();
						break;
					case videoControls.soundPauseBtn :
						if (videoControls.soundPauseBtn.currentLabel == "silence") {
							videoControls.soundPauseBtn.gotoAndStop("sound");
							player.unmuteClicked();
							
							
						} else {
							videoControls.soundPauseBtn.gotoAndStop("silence");
							player.muteClicked();
							//player.removeListXmlData();
							
						}	
						break;
					default :
						break;
				}
			if (typ == MouseEvent.MOUSE_DOWN) {
				var bolVolumeScrub:Boolean = true;
	
				// start drag
				//videoControls.mcVolumeScrubber.startDrag(true, new Rectangle(318, 19, 53, 0)); // NOW TRUE
				//mcVideoControls.mcVolumeScrubber.startDrag(true, new Rectangle(318, 19, 53, 0)); // NOW TRUE
			}
			} else {
				if (targ != videoControls)
					targ.alpha = typ == MouseEvent.MOUSE_OVER ? 0.5 : 1;
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@inheritDoc
		 */
		override protected function complete(event:Event = null):void
		{
			player.stopVideoPlayer();
			player.vidDisplay.visible = false;
			
			removeVideoControls();
			
			sourceTarget.mouseEnabled = true;
			sourceTarget.mouseChildren = false;
			sourceTarget.buttonMode = true;
			
			mcSource.gotoAndStop("off");
			
			mcSource.removeEventListener(MouseEvent.MOUSE_OVER, sourceTargetMouseHandler, false);
			mcSource.removeEventListener(MouseEvent.MOUSE_OUT, sourceTargetMouseHandler, false);
			mcSource.removeEventListener(MouseEvent.CLICK, sourceTargetMouseHandler, false);
			
			videoControls = null;
			player = null;
			mcSource = null;
			targetBounds = null;
			
			super.complete();
		}
	
	}

}

