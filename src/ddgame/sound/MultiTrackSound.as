package ddgame.sound {
	
	import ddgame.sound.SoundTrack;
	
	/**
	 *	Manager de piste sons.
	 * TODO documenter la classe
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class MultiTrackSound {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function MultiTrackSound ()
		{
			_tracks = [];
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
				
		protected var _tracks:Array;
		protected var _volume:Number;
		protected var _isPlaying:Boolean;
		protected var _mute:Boolean;
	
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Retourne la liste des pistes
		 */
		public function get tracks () : Array
		{
			return _tracks;
		}
		
		/**
		 * Retourne le nombre de pistes
		 */
		public function get trackCount () : int
		{
			return _tracks.length;
		}
		
		/**
		 * Retourne l'état sourdine
		 */
		public function get muted () : Boolean
		{
			return _mute;
		}
		
		/**
		 * Retourne l'état de lecture
		 */
		public function get isPlaying () : Boolean
		{
			return _isPlaying;
		}
		
		/**
		 * Retourne le volume sonore
		 */
		public function get volume () : Number
		{
			return _volume;
		}
		
		/**
		 * Ajuste le volume
		 * TODO effectué un ajustement relatif au volume
		 * de chaque piste
		 */
		public function set volume (val:Number) : void
		{
			if (val != _volume) _volume = val;
			
			for each (var t:SoundTrack in _tracks)
				t.volume = val;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Retourne une piste depuis son index
		 *	@param ind int
		 *	@return SoundTrack
		 */
		public function getTrack (ind:int) : SoundTrack
		{
			return _tracks[ind] as SoundTrack;
		} 
		
		/**
		 * Crée une piste
		 * @return SoundTrack
		 */
		public function createTrack () : SoundTrack
		{
			var t:SoundTrack = new SoundTrack();
			addTrack(t);
			
			return t;
		}
		
		/**
		 * Ajoute une piste au dernier index
		 *	@param track SoundTrack
		 */
		public function addTrack (track:SoundTrack) : void
		{
			_tracks.push(track);
			
			if (_mute) track.mute();
			
			if (_isPlaying)
			{
				// TODO lancer la lecture de la piste à la position
				// actuelle de la tête de lecture
			}
		}
		
		/**
		 * Supprime une piste
		 *	@param track SoundTrack
		 */
		public function removeTrack (track:SoundTrack) : void
		{
			var ind:int = _tracks.indexOf(track);
			if (ind > -1)
			{
				removeTrackAt(ind);
			}
		}
		
		/**
		 * Supprime une piste d'après son index
		 *	@param ind int
		 */
		public function removeTrackAt (ind:int) : void
		{
			var track:SoundTrack = getTrack(ind);
			if (!track) return;
			
			if (track.isPlaying) track.stop();
			_tracks.splice(ind, 1);
		}
		
		/**
		 *	Supprime toutes les pistes
		 */
		public function removeAllTracks () : void
		{
			for each (var t:SoundTrack in _tracks) {
				removeTrack(t);
			}
			
			if (_isPlaying) _isPlaying = false;
		}
		
		/**
		 * Lance la lecture synchronisée des pistes
		 *	@param startTime Number
		 *	@param loops int
		 */
		public function play (startTime:Number = 0, loops:int = 0) : void
		{
			if (_isPlaying) return;
			
			for each (var t:SoundTrack in _tracks) {
				t.play(startTime, loops);
			}
			
			_isPlaying = true;
		}
		
		/**
		 *	Arrête la lecture des pistes
		 */
		public function stop () : void
		{
			if (!_isPlaying) return;
			
			for each (var t:SoundTrack in _tracks) {
				t.stop();
			}
			
			_isPlaying = false;	
		}
		
		/**
		 *	Met en pause la lecture des pistes
		 */
		public function pause () : void
		{
			if (!_isPlaying) return;

			for each (var t:SoundTrack in _tracks) {
				t.pause();
			}
			
			_isPlaying = false;
		}
		
		public function resume () : void
		{
			if (_isPlaying) return;

			for each (var t:SoundTrack in _tracks) {
				t.resume();
			}
			
			_isPlaying = true;
		}
		
		public function mute () : void
		{
			if (_mute) return;
			
			for each (var t:SoundTrack in _tracks) {
				t.mute();
			}
			
			_mute = true;
		}
		
		public function unMute () : void
		{
			if (!_mute) return;
			
			for each (var t:SoundTrack in _tracks) {
				t.unMute();
			}
			
			_mute = false;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}

