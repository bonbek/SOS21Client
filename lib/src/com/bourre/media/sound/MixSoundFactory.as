/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */	

package com.bourre.media.sound {
	import com.bourre.collection.HashMap;
	import com.bourre.error.NoSuchElementException;
	import com.bourre.log.PixlibDebug;	

	/**
	 * <pre>
	 * You can control the SoundFactory with :
	 * 		a master volume
	 * 		gain of a sound ( relative to the master volume)
	 * 		pan of a sound
	 * 
	 * For instance, if the master volume is to 0.5 and the gain of a sound to 0.5
	 * the real volume for this sound is 0.25.
	 * </pre>
	 * 
	 * @author Francis Bourre 	(Pixlib.com.bourre.media.sound.MixSoundFactory)
	 * @author Steve Lombard 	(rewrite for lowRa)
	 * @version 1.0
	 */
	 
	public class MixSoundFactory extends SoundFactory
	{
		private var _nVolume : Number = 1;
				
		public function MixSoundFactory()
		{
		}
		
		/**
		 * 
		 * Get Master Volume ( 0 to 1 ). By default master volume is set to 1.
		 * 
		 * @see #setVolume()
		 */
		public function getVolume() : Number
		{		
			return _nVolume;
		}
		
		/**
		 * Set Master Volume ( 0 to 1 ). By default master volume is set to 1.
		 * 
		 * @param 0 to 1
		 * 
		 * @see #getVolume()
		 */		
		public function setVolume(n : Number ) : void
		{		
			if( n < 0 )
			{
				n = 0;
			}
			else if( n > 1 )
			{
				n = 1;
			}
			_nVolume = n;
			var a : Array = _mSoundTransform.getKeys();
			var i : Number = a.length;
			while( --i > -1 )
			{
				_adjustVolume( a[i] );
			}								
		}
		
		/**
		 * @inheritDoc
		 * 
		 * @see #addSounds()
		 * @see com.bourre.media.sound.SoundFactory#addSound()
		 */
		 public override function addSound( id : String ) : void
		 {
		 	super.addSound( id  );
		 	_adjustVolume( id );
		 }
		 
		/**
		 * @inheritDoc
		 * 
		 * @see #addSound()
		 * @see com.bourre.media.sound.SoundFactory#addSounds()
		 */
		 public override function addSounds( a:Array ) : void
		 {
		 	super.addSounds( a );
			a = _mSoundTransform.getKeys();		
			var i : uint = a.length;
			while( --i > -1 )
			{
				_adjustVolume( a[i] );
			}
		 }
		  
		/**
		 * Get gain : volume for a sound ( 0 to n ). By default all sounds gain is set to 1 ( equals to 100% ).
		 * 
		 * @param sound's class identifier in the library
		 * 
		 * @see #setGain()
		 * @see #setAllGain()
		 */ 		
		public function getGain( id : String ) : Number
		{
			if( _mSoundTransform.containsKey( id ) )
			{
				return _mSoundTransform.get( id ).getGain();
			}
			else
			{
				PixlibDebug.ERROR("MixSoundFactory.getGain("+id+") : this id doesn't exist");					
				throw new NoSuchElementException("MixSoundFactory.getGain("+id+") : this id doesn't exist") ;				
			}
		}
		
		/**
		 * Set gain : volume for a sound ( 0 to n ). By default all sounds gain is set to 1( equals to 100% ).
		 * 
		 * @param sound's class identifier in the library
		 * @param a number between 0 and n for this sound volume
		 * 
		 * @see #getGain()
		 * @see #setAllGain()
		 */ 
		public function setGain( id : String, n : Number ) : void
		{
			if( _mSoundTransform.containsKey( id ) )
			{
				_mSoundTransform.get( id ).setGain( n );
				_adjustVolume( id );
			}
			else
			{
				PixlibDebug.ERROR("MixSoundFactory.setGain("+id+", "+n+") : this id doesn't exist");					
				throw new NoSuchElementException("MixSoundFactory.setGain("+id+", "+n+") : this id doesn't exist") ;					
			}			
		}
		
		/**
		 * Set the same gain for all sounds ( 0 to n ). By default all sounds gain is set to 1 ( equals to 100% ).
		 * 
		 * @param a number between 0 and n for all sound volume
		 * 
		 * @see #getGain()
		 * @see #setGain()
		 */ 		
		public function setAllGain( n : Number ) : void
		{
			var a : Array = _mSoundTransform.getKeys();		
			var i : uint = a.length;
			while( --i > -1 )
			{
				_mSoundTransform.get( a[i] ).setGain( n );
				_adjustVolume( a[i] );
			}	
		}
		
		
		/**
		 * Get Pan of a sound ( -1 to 1 ). By default all sounds pan is set 0 .
		 * 
		 * @param sound's class identifier in the library
		 * 
		 * @see #setPan()
		 * @see #setAllPan()
		 */ 
		public function getPan( id : String ) : Number
		{		
			if( _mSoundTransform.containsKey( id ) )
			{
				return _mSoundTransform.get( id ).getPan();
			}		
			else
			{
				PixlibDebug.ERROR("MixSoundFactory.getPan("+id+") : this id doesn't exist");					
				throw new NoSuchElementException("MixSoundFactory.getPan("+id+") : this id doesn't exist") ;					
			}			
		}
		
		/**
		 * Set Pan of a sound ( -1 to 1 ). By default all sounds pan is set to 0.
		 * 
		 * @param sound's class identifier in the library
		 * @param a number between -1 and 1 for its volume ( 0 is the center )
		 * 
		 * @see #getPan()
		 * @see #setAllPan()
		 */ 		
		public function setPan( id : String, n : Number ) : void
		{		
			if( _mSoundTransform.containsKey( id ) )
			{
				if( n < -1 )
				{
					n = -1;
				}
				else if( n > 1 )
				{
					n =	 1;
				}
				_mSoundTransform.get( id ).setPan( n );
				_updateChannel( id );
			}		
			else
			{
				PixlibDebug.ERROR("MixSoundFactory.getPan("+id+") : this id doesn't exist");					
				throw new NoSuchElementException("MixSoundFactory.getPan("+id+") : this id doesn't exist") ;					
			}			
		}
		
		/**
		 * Set the same pan for all sounds ( -1 to 1 ). By default all sounds pan is 0.
		 * 
		 * @param a number between -1 and 1 for its volume ( 0 is the center )
		 * 
		 * @see #getPan()
		 * @see #setPan()
		 */ 		
		public function setAllPan( n : Number ) : void
		{		
			if( n < -1 )
			{
				n = -1;
			}
			else if( n > 1 )
			{
				n =	 1;
			}
			
			var a : Array = _mSoundTransform.getKeys();		
			var i : uint = a.length;
			while( --i > -1 )
			{
				_mSoundTransform.get( a[i] ).setPan( n );
				_updateChannel( a[i] );
			}	
		}
		
		private function _adjustVolume( id : String ) : void
		{
			var v:Number = _calculVolume( getGain( id ) );
			_mSoundTransform.get( id ).setVolume( v );
			_updateChannel( id );
		}
		
		private function _calculVolume( nGain : Number ): Number
		{
			var v : Number = nGain * _nVolume;
			if( v > 1) v = 1;
			return v;
		}
		
		private function _updateChannel( id : String ) : void
		{		
			var i : uint = _aChannelsSounds.length;
			while( --i > -1 )
			{
				if( _aChannelsSounds[i].id == id )
				{
					_aChannelsSounds[i].soundChannel.soundTransform = _mSoundTransform.get( id ).getSoundTransform();
				}
			}			
		}		

		
						
	}
}