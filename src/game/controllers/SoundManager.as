package game.controllers
{
	import game.data.*;
	import game.utils.*;
	import game.errors.*;
	import game.objects.*;

	import flash.net.*;
	import flash.media.*;
	import flash.utils.*;
	import flash.events.*;

	/**
	 * The SoundManager creates, initializes and manages
	 * all sounds in the game.
	 */
	public class SoundManager
	{
		public static const TYPE_EFFECT:String			= 'effect';
		public static const TYPE_AMBIENT:String			= 'ambient';
		public static const TYPE_SOUNDTRACK:String		= 'soundtrack';

		public static const FADE_IN:String				= 'fadeIn';
		public static const FADE_OUT:String				= 'fadeOut';

		public static const VOLUME_EFFECT:Number		= 1;
		public static const VOLUME_AMBIENT:Number		= .25;
		public static const VOLUME_SOUNDTRACK:Number	= .6;

		private static const NUM_LOOPS:int				= 9999;
		private static const FADE_DELAY:int				= 50;
		private static const FADE_DEFAULT:int			= 1000;

		private var sounds:Object;
		private var channels:Object;

		private var fadeArray:Array;
		private var timerFade:Timer;
		private var mute:Boolean;

		public function SoundManager():void
		{
		}

		/**
		 * Creates all sounds in the GameData.sound container
		 * and adds them to the sound manager.
		 */
		public function initAllSounds():void
		{
			TraceUtil.addLine( 'SoundManager initSound() >>> Initializing sounds...' );

			this.mute			= false;
			this.timerFade		= null;

			this.sounds			= new Object();
			this.channels		= new Object();
			this.fadeArray		= new Array();

			for ( var id:String in GameData.sound ) {

				TraceUtil.addLine( 'SoundManager initSound() id: ' + id );

				var gameSound:GameSound	= GameData.sound[ id ] as GameSound;
				var sound:Class			= gameSound.soundClass;
				gameSound.sound			= new sound();
				this.sounds[ id ]		= gameSound;
				//TraceUtil.addLine( 'SoundManager initSound() sound: ' + this.sounds[ id ].sound );
			}
		}

		/**
		 * Adds a sound to the sound manager.
		 */
		public function addSound( id:String, sound:GameSound ):void
		{
			this.sounds[ id ] = sound;
		}

		/**
		 * Returns the current state of the sound system (on/off).
		 * If isMute is true, the game's sound has been turned off.
		 */
		public function isMute():Boolean
		{
			return this.mute;
		}

		/**
		 * Toggles the sound system between on and off.
		 */
		public function toggleSound():void
		{
			if ( this.mute ) {

				this.mute = false;
				this.unMuteSound();

			} else {

				this.mute = true;
				this.muteSound();
			}
		}

		/**
		 * Gets the length of the sound in milliseconds. Returns zero
		 * if the sound does not exist.
		 */
		public function getSoundLength( name:String ):Number
		{
			if ( this.sounds[ name ] ) {

				var sound:GameSound = this.sounds[ name ];
				//TraceUtil.addLine( 'SoundManager getSoundLength() length: ' + this.sounds[ name ].sound.length );
				return sound.sound.length;

			} else {

				//TraceUtil.addLine( 'SoundManager getSoundLength() >>> length = 0' );
				return 0;
			}
		}

		/**
		 * When the sound is playing, returns the current point that is
		 * being played in the sound file in milliseconds. When the sound
		 * is stopped or paused, returns the last point that was played.
		 * Returns zero if the sound does not exist or has never been played.
		 */
		public function getSoundPosition( name:String ):Number
		{
			if ( this.channels[ name ] ) {

				var channel:SoundChannel = this.channels[ name ];
				//TraceUtil.addLine( 'SoundManager getSoundPosition() position: ' + this.channels[ name ].position );
				return channel.position;

			} else {

				//TraceUtil.addLine( 'SoundManager getSoundPosition() >>> position = 0' );
				return 0;
			}
		}

		/**
		 * Adds an event listener to a sound that is playing and calls the
		 * callback method when the sound has finished. Calls the callback
		 * method immediately if the sound is not playing or does not exist.
		 */
		public function addCompleteListener( name:String, callback:Function ):void
		{
			if ( this.channels[ name ] ) {

				var channel:SoundChannel = this.channels[ name ];
				channel.addEventListener( Event.SOUND_COMPLETE, callback );

			} else {

				callback( new Event( Event.SOUND_COMPLETE ) );
			}
		}

		/**
		 * Removes the complete listener from the sound.
		 * See the addCompleteListener() method.
		 */
		public function removeCompleteListener( name:String, callback:Function ):void
		{
			if ( this.channels[ name ] ) {

				var channel:SoundChannel = this.channels[ name ];
				channel.removeEventListener( Event.SOUND_COMPLETE, callback );
			}
		}

		/**
		 * Returns the state of the isPlaying property of a GameSound.
		 * Returns false if the sound does not exist.
		 */
		public function isPlaying( name:String ):Boolean
		{
			if ( this.channels[ name ] ) {

				var sound:GameSound = this.sounds[ name ];
				return sound.isPlaying;
			}

			return false;
		}

		/**
		 * Returns the initial volume of a GameSound as defined when
		 * it was created. Returns zero if the sound does not exist.
		 * The range of a sound volume is a Number between 0 and 1.
		 */
		public function getVolume( name:String ):Number
		{
			if ( this.sounds[ name ] ) {
				
				var sound:GameSound = this.sounds[ name ];
				return sound.volume;
			}
			
			return 0;
		}

		/**
		 * Returns the current volume of a GameSound that is currently
		 * playing. Returns zero if the sound is not playing.
		 */
		public function getCurrentVolume( name:String ):Number
		{
			if ( this.channels[ name ] ) {

				var channel:SoundChannel = this.channels[ name ];
				var st:SoundTransform = channel.soundTransform;
				return st.volume;
			}

			return 0;
		}

		/**
		 * Sets the volume of a sound that is currently playing. The new volume can
		 * be set with a fade effect (fade in or out).
		 * 
		 * @param name:			The name (ID) of the sound.
		 * @param volume:		The volume to which the sound should be set.
		 * @param fade:			Should the sound fade to the new volume instead
		 * 						of being set directly? Default is false.
		 * @param fadeLength:	The length of time in milliseconds the sound should take to
		 * 						fade to the new volume. Default is 1000 milliseconds (1 second).
		 */
		public function setVolume( name:String, volume:Number, fade:Boolean = false, fadeLength:int = SoundManager.FADE_DEFAULT ):void
		{
			var sound:GameSound = this.sounds[ name ];

			if ( !sound ) return;

			sound.isPlaying = true;

			if ( fade ) {

				// Remove the fade element if one
				// with the same name already exists.
				this.removeFadeElement( name );

				var delta:Number = SoundManager.FADE_DELAY / fadeLength;
				this.addFadeElement( name, volume, delta );
				this.startFadeTimer();

			} else {

				var loops:int = this.getLoops( sound.type );
				var st:SoundTransform = new SoundTransform();
				st.volume = volume;
				this.setChannel( name, st, loops );
			}
		}

		/**
		 * Plays a sound file. If the sound is of SoundManager.TYPE_SOUNDTRACK or SoundManager.TYPE_AMBIENT,
		 * the file will loop continuously. The sound can be started with a fade in effect.
		 * 
		 * @param name:			The name (ID) of the sound.
		 * @param fade:			Should the sound fade in when it starts playing? Default is false.
		 * @param fadeLength:	The length of time in milliseconds the sound should take to
		 * 						fade to the new volume. Default is 1000 milliseconds (1 second).
		 * @param volume		The volume at which the sound starts playing (or fades in to). If no
		 * 						volume is given, the default volume defined for the sound is used.
		 */
		public function playSound( name:String, fade:Boolean = false, fadeLength:int = SoundManager.FADE_DEFAULT, volume:Number = 0 ):void
		{
			var sound:GameSound = this.sounds[ name ];

			if ( !sound ) {

				TraceUtil.addLine( 'SoundManager playSound() ==> WARNING >>> Sound not found: ' + name );
				return;
			}

			if ( fade ) {

				var loops:int = this.getLoops( sound.type );
				var st:SoundTransform = new SoundTransform();
				st.volume = 0;
				if ( !this.setChannel( name, st, loops ) ) return;
			}

			volume = ( volume == 0 ) ? sound.volume : volume;

			sound.isPlaying = true;
			this.setVolume( name, volume, fade, fadeLength );
		}

		/**
		 * Stops a sound that is currently playing. Optionally, the
		 * sound can fade out.
		 * 
		 * @param name:			The name (ID) of the sound.
		 * @param fade:			Should the sound fade out as it is being stopped? Default is false.
		 * @param fadeLength:	The length of time in milliseconds the sound should take to
		 * 						fade out. Default is 1000 milliseconds (1 second).
		 */
		public function stopSound( name:String, fade:Boolean = false, fadeLength:int = SoundManager.FADE_DEFAULT ):void
		{
			var timer:Timer;
			var sound:GameSound = this.sounds[ name ];

			if ( !sound ) {

				TraceUtil.addLine( 'SoundManager stopSound() ==> WARNING >>> Sound not found: ' + name );
				return;
			}

			if ( !this.channels[ name ] ) {

				if ( sound.isPlaying ) {

					sound.isPlaying = false;
				}

				return;
			}

			if ( fade ) {

				this.setVolume( name, 0, fade, fadeLength );

			} else {

				this.channels[ name ].stop();
				sound.isPlaying = false;
			}
		}

		/**
		 * Stops all sounds that are currently playing. Optionally, the
		 * sounds can be faded out.
		 * 
		 * @param fade:			Should the sounds fade out as they are being stopped? Default is false.
		 * @param fadeLength:	The length of time in milliseconds the sounds should take to
		 * 						fade out. Default is 1000 milliseconds (1 second).
		 */
		public function stopAllSounds( fade:Boolean = false, fadeLength:int = SoundManager.FADE_DEFAULT ):void
		{
			var name:String;

			if ( fade ) {

				for ( name in this.channels ) {

					if ( this.sounds[ name ].isPlaying ) {

						this.setVolume( name, 0, fade, fadeLength );
					}
				}

			} else {

				for ( name in this.channels ) {

					this.channels[ name ].stop();
					this.sounds[ name ].isPlaying = false;
				}
			}
		}

		/**
		 * Lists all channels in a trace.
		 */
		public function listAllChannels():void
		{
			var name:String;

			for ( name in this.channels ) {

				TraceUtil.addLine( 'SoundManager listAllChannels() name: ' + name );
			}
		}

		/**
		 * Gets the number of loops for a certain sound type.
		 * Sounds with SoundManager.TYPE_EFFECT do not loop.
		 * All other sound types will loop 9999 times.
		 */
		private function getLoops( type:String ):int
		{
			if ( type == SoundManager.TYPE_EFFECT ) {

				return 0;

			} else {

				return SoundManager.NUM_LOOPS;
			}
		}

		/**
		 * Set the channel for a sound that starts playing.
		 */
		private function setChannel( name:String, st:SoundTransform, loops:int ):Boolean
		{
			var sound:GameSound = this.sounds[ name ];

			if ( !sound ) return false;

			try {

				//TraceUtil.addLine( 'SoundManager setChannel() name: ' + name );
				//TraceUtil.addLine( 'SoundManager setChannel() sound: ' + this.sounds[ name ].sound );
				var channel:SoundChannel = sound.sound.play( 0, loops, st );

				if ( channel ) {

					this.channels[ name ] = channel;

					// Add an event listener if this is a sound effect. That way we
					// can set the isPlaying property to false when the sound is done.
					if ( sound.type == SoundManager.TYPE_EFFECT ) {

						channel.addEventListener( Event.SOUND_COMPLETE, this.soundEffectComplete );
					}

					return true;
				}

				return false;

			} catch( error:Error ) {

				TraceUtil.addLine( 'SoundManager setChannel() ===>>> CHANNEL ERROR -- sound:' + name + '; msg:' + error.message );
/*
				var msgNo:String	= GameError.ERR_NO_1112;
				var msgTxt:String	= GameError.ERR_TXT_1112;
				var msgData:String	= 'Sound name: ' + name;

				GameError.setError( msgNo, msgTxt, msgData );
*/
				return false;
			}

			return true;
		}

		/**
		 * Sets the isPlaying property of a sound effect to false
		 * when the sound has stopped playing.
		 */
		private function soundEffectComplete( event:Event ):void
		{
			var channel:SoundChannel = event.currentTarget as SoundChannel;
			channel.removeEventListener( Event.SOUND_COMPLETE, this.soundEffectComplete );
			//TraceUtil.addLine( 'SoundManager soundEffectComplete() >>> A sound effect has completed -- channel:' + channel );

			for ( var name:String in this.channels ) {

				if ( channel == this.channels[ name ] ) {

					//TraceUtil.addLine( 'SoundManager soundEffectComplete() >>> The following sound effect has completed:' + name );
					var sound:GameSound = this.sounds[ name ];
					sound.isPlaying = false;
				}
			}
		}

		/**
		 * Completely mutes the sound of the sound system. All
		 * sounds continue playing normally when sound is muted.
		 */
		private function muteSound( fade:Boolean=false ):void
		{
			this.setMixerVolume( 0 );
		}

		/**
		 * Turns the sound of the sound system back on.
		 */
		private function unMuteSound( fade:Boolean=false ):void
		{
			this.setMixerVolume( 1 );
		}

		/**
		 * Sets the volume of the sound system.
		 */
		private function setMixerVolume( volume:Number ):void
		{
			var st:SoundTransform = new SoundTransform();
			st.volume = volume;
			SoundMixer.soundTransform = st;
		}

		/**
		 * Adds a fade element (sound) to the fade process.
		 * 
		 * @param name:		The name (ID) of the sound element.
		 * @param volume:	The volume to which the sound will fade.
		 * @param slice:	The amount by which the volume will increase/decrease.
		 * @param mult:		Fade in or out. 1 = fade in, -1 = fade out.
		 */
		private function addFadeElement( name:String, volume:Number, delta:Number ):void
		{
			var element:Object = { name:name, volume:volume, delta:delta };
			this.fadeArray.push( element );
		}

		/**
		 * Removes a fade element from the fade process.
		 */
		private function removeFadeElement( name:String ):void
		{
			for ( var i:uint = 0; i < this.fadeArray.length; i++ ) {

				var element:Object = this.fadeArray[ i ];

				if ( element.name == name ) {

					this.fadeArray.splice( i, 1 );
					return;
				}
			}
		}

		private function startFadeTimer():void
		{
			if ( !this.timerFade ) {

				this.timerFade = new Timer( SoundManager.FADE_DELAY, 0 );
				this.timerFade.addEventListener( TimerEvent.TIMER, this.fade );
				this.timerFade.start();
			}
		}

		/**
		 * This is the fade process. It is executed each predefined
		 * time interval (currently every 50 milliseconds) via the
		 * fadeTimer. Each sound's volume is either increased or
		 * decreased by its delta, depending on whether the target
		 * volume is greater or less than the sound's current volume.
		 * 
		 */
		private function fade( event:Event ):void
		{
			var nextFade:Array = new Array();

			var st:SoundTransform;
			var volume:Number;
			var target:Number;
			var delta:Number;
			var name:String;

			var len:uint		= this.fadeArray.length;
			var fadeIn:Boolean	= false;

			// Go through all the sounds to be faded out
			for ( var i:uint = 0; i < len; i++ ) {

				var fadeElement:Object = Object( this.fadeArray[ i ] );

				name	= fadeElement.name;
				target	= fadeElement.volume;
				delta	= fadeElement.delta;

				var sound:GameSound			= this.sounds[ name ];
				var channel:SoundChannel	= this.channels[ name ];

				// If the channel doesn't exist, display an error
				if ( !channel ) {

					TraceUtil.addLine( 'SoundManager fade() ==> ERROR: Channel missing!!! name -- ' + name );
					this.timerFade.removeEventListener( TimerEvent.TIMER, this.fade );
					this.timerFade.stop();
					this.timerFade = null;
/*
					var msgNo:String	= GameError.ERR_NO_1113;
					var msgTxt:String	= GameError.ERR_TXT_1113;
					var msgData:String	= 'Sound name: ' + name;

					GameError.setError( msgNo, msgTxt, msgData );
*/
					return;
				}

				// Only process sounds that are still playing
				if ( sound.isPlaying ) {

					volume = channel.soundTransform.volume;

					//TraceUtil.addLine( 'SoundManager fade() name:' + name + ' volume:' + volume + ' target:' + target + ' delta:' + delta );

					// Fade in
					if ( volume < target ) {

						fadeIn = true;
						volume += delta;
						if ( volume > target ) volume = target;

					// Fade out
					} else {

						volume -= delta;
						if ( volume < 0 ) volume = 0;
						if ( volume < target ) volume = target;
					}

					st						= new SoundTransform();
					st.volume				= volume;
					channel.soundTransform	= st;

					// Fade in
					if ( fadeIn ) {

						// If the sound has not yet reached its target volume,
						// we insert the element into the new fade array.
						if ( volume < target ) {

							nextFade.push( this.fadeArray[ i ] );
						}

					// Fade out
					} else {

						switch ( true ) {

							// If the sound has not yet reached its target volume,
							// we insert the element into the new fade array.
							case ( volume > target )	:
								nextFade.push( this.fadeArray[ i ] );
								break;

							// If the sound has reached zero, we stop the sound
							// and mark it as no longer playing.
							case ( volume == 0 )	:
								channel.stop();
								sound.isPlaying = false;
								break;

							default:
						}
					}
				}
			}

			this.fadeArray = nextFade;

			// If all sounds have been faded, then end the timer.
			if ( this.fadeArray.length == 0 ) {

				TraceUtil.addLine( 'SoundManager fade() >>> Sound fade completed!!!' );

				this.fadeArray = new Array();

				this.timerFade.removeEventListener( TimerEvent.TIMER, this.fade );
				this.timerFade.stop();
				this.timerFade = null;
			}
		}
	}
}
