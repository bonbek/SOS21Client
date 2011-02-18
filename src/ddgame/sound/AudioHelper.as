package ddgame.sound {
	
	import flash.events.*;
	import flash.utils.Dictionary;
	import flash.net.URLRequest;
	
	import com.sos21.helper.AbstractHelper;
	import com.sos21.events.BaseEvent;
	
	import ddgame.client.proxy.DatamapProxy;
	import ddgame.client.events.EventList;
	import ddgame.helper.HelperList;
	import ddgame.sound.MultiTrackSound;
	import ddgame.sound.SoundTrack;
	import ddgame.events.EventList;
	import flash.media.Sound;
	
	/**
	 *	Helper gestion du sons
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class AudioHelper extends AbstractHelper {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = HelperList.AUDIO_HELPER;

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function AudioHelper ()
		{
			super(NAME);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		// son multi-pistes pour la musique (fond sonore de la scène)
		private var _music:MultiTrackSound;
		// listes des pistes musiques par fichiers
		private var _musicTracks:Dictionary;
		// liste des fx's (SoundTrack's)
		private var _sounds:Dictionary;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Définit le volume sonore global (musique et sons)
		 */
		public function set volume (val:Number) : void
		{
			// TODO
		}
		
		/**
		 * Définit le volume de la musique
		 */
		public function set musicVolume (val:Number) : void
		{
			_music.volume = val;
		}
		
		/**
		 * Retourne l'état sourdine de la music
		 */
		public function get musicMuted () : Boolean
		{
			return _music.muted;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Ajoute une piste à la musique
		 *	@param url String url du fichier zique
		 */
		public function addToMusic (url:String) : void
		{
			var track:SoundTrack = new SoundTrack();
			track.load(new URLRequest(url));
			_music.addTrack(track);
			_musicTracks[url] = track;
		}
		
		/**
		 * Supprime une piste de musique
		 *	@param url String url du fichier zique
		 */
		public function removeFromMusic (url:String) : void
		{
			var track:SoundTrack = _musicTracks[url];
			_music.removeTrack(track);
			delete _musicTracks[url];
		}
		
		/**
		 * Lance la lecture de la musique
		 *	@param loops int boucles (0 pour répéter indéfiniment)
		 */
		public function playMusic (loops:int = 0) : void
		{
			_music.play(0, loops);
		}
		
		/**
		 *	Stop la lecture de la musique
		 */
		public function stopMusic () : void
		{
			_music.stop();
		}
		
		/**
		 *	Met la musique en pause
		 */
		public function pauseMusic () : void
		{
			_music.pause();
		}
		
		/**
		 * Reprend la lecture de la zique
		 */
		public function resumeMusic () : void
		{
			_music.resume();
		}
		
		/**
		 *	Met en sourdine la musique
		 */
		public function muteMusic () : void
		{
			if (!_music.muted)
			{
				_music.mute();
				sendEvent(new BaseEvent(ddgame.events.EventList.MUSIC_EVENT, "musicMuted"));
			}
		}
		
		/**
		 *	Enlève la sourdine de la musique
		 */
		public function unMuteMusic () : void
		{
			if (_music.muted)
			{
				_music.unMute();
				sendEvent(new BaseEvent(ddgame.events.EventList.MUSIC_EVENT, "musicUnMuted"));
			}			
		}
		
		/**
		 * Ajoute un son
		 *	@param url String url du fichier son ou Objet son
		 *	@param autoPlay Boolean lance la lecture
		 */
		public function addSound (sndOrUrl:*, autoPlay:Boolean) : SoundTrack
		{
			// Objet retour
			var soundTrack:SoundTrack = getSound(sndOrUrl);
			
			// On est sur un nouveau son
			if (!soundTrack)
			{
				soundTrack = new SoundTrack();				
				if (sndOrUrl is String) {
					var url:String = sndOrUrl as String;
					soundTrack.load(new URLRequest(url));
					_sounds[url] = soundTrack;
				}
				else if (sndOrUrl is Sound) {
					var snd:Sound = sndOrUrl as Sound;
					soundTrack.sound = snd;
					_sounds[snd.url] = soundTrack;
				}
			}
			
			if (autoPlay) soundTrack.play();
			
			return soundTrack;
		}
		
		/**
		 * Supprime un son
		 *	@param url String url du fichier son
		 */
		public function removeSound (urlOrSnd:*) : void
		{
			var st:SoundTrack = getSound(urlOrSnd);
			if(st)
			{
				if (st.isPlaying) st.stop();
				delete _sounds[st.sound.url];
			}
		}
		
		public function removeSoundTrack (soundTrack:SoundTrack) : void
		{
			removeSound(soundTrack.sound);
		}
		
		/**
		 * Retourne un SoundTrack enregistré
		 *	@param urlOrSnd String ou Sound
		 *	@return SoundTrack
		 */
		public function getSound (urlOrSnd:*) : SoundTrack
		{
			var sndTrack:SoundTrack;
			switch (true)
			{
				case urlOrSnd is String :
					sndTrack = _sounds[urlOrSnd];
					break;
				case urlOrSnd is Sound :
					sndTrack = _sounds[Sound(urlOrSnd).url];
					break;
			}

			return sndTrack;
		}
		
		/**
		 * Lance la lecture d'un son ajouté précédement
		 *	@param surl String url du fichier son
		 *	@param loop int nombre de répétition
		 */
		public function playSound (urlOrSnd:*, loops:int = 0) : void
		{
			var st:SoundTrack = getSound(urlOrSnd);
			if (st)
				st.play(0, loops);
		}
		
		/**
		 * Stope la lecture du son
		 *	@param surl String url du fichier son
		 */
		public function stopSound (urlOrSnd:*) : void
		{
			var st:SoundTrack = getSound(urlOrSnd);
			if (st)
				st.stop();
		}
		
		/**
		 *	Stop la lecture de tous les son
		 */
		public function stopAllSounds () : void
		{
			for each (var s:SoundTrack in _sounds)
				s.stop();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize () : void
		{
			_music = new MultiTrackSound();
			_musicTracks = new Dictionary(true);
			_sounds = new Dictionary(true);			
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * Default Event handler
		 */
		override public function handleEvent(event:Event):void
		{
			switch(event.type)
			{
				case ddgame.client.events.EventList.DATAMAP_PARSED :
				{
					var url:String = datamap.ambientSoundFile;
					if (url)
					{
						addToMusic(url);
						playMusic();
					}
					break;
				}
				case ddgame.client.events.EventList.CLEAR_MAP :
				{
					stopMusic();
					stopAllSounds();
					url = datamap.ambientSoundFile;
					removeFromMusic(url);
					break;
				}
				default :
				{ break; }				
			}
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @private
		 * Retourne la ref au datamap proxy
		 */
		protected function get datamap () : DatamapProxy
		{
			return facade.getProxy(DatamapProxy.NAME) as DatamapProxy;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function listInterest () : Array
		{
			return [	ddgame.client.events.EventList.DATAMAP_PARSED,
						ddgame.client.events.EventList.CLEAR_MAP ];
		}

	}
	
}