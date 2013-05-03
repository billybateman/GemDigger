package game.controllers
{
	import game.data.*;
	import game.view.*;
	import game.utils.*;
	import game.events.*;

	import flash.net.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.display.*;

	/**
	 * The TimeManager class is used to synchronize several game timers
	 * with a single master timer. The start() method starts a Timer
	 * class object which loops approximately every second in the 
	 * countDown() method.
	 * 
	 * Usage:	Game timers are added with addTimer(). After timers have
	 * 			been added, one of them must be set as the master timer
	 * 			using the setMaster() method.
	 */
	public class TimeManager extends EventDispatcher
	{
		public static const SECONDS_IN_MINUTE:uint	= 60;
		public static const MILLI_SECONDS:Number	= 1000;

		private var _timer:Object;
		private var timer:Timer;
		private var startTime:int;
		private var seconds:int;
		private var delay:Number;
		private var master:String;

		public function TimeManager()
		{
			_timer = new Object();
			this.unSetMaster();
		}

		/**
		 * Starts the master timer loop.
		 */
		public function start():void
		{
			if ( ( this.master == null ) || ( this.seconds <= 0 ) ) {

				//TraceUtil.addLine( 'TimeManager start() >>> WARNING: Timer was not started.' );
				return;
			}

			this.delay = TimeManager.MILLI_SECONDS;
			this.activateTimers();
			this.startMasterTimer( TimeManager.MILLI_SECONDS );
		}

		/**
		 * Ends the timer completely and resets the
		 * master timer to zero. In order to restart
		 * the timer, the master would have to be
		 * set again.
		 */
		public function stop( end:Boolean=true ):void
		{
			if ( ( this.timer is Timer ) && ( this.timer.running ) ) {

				this.stopMasterTimer();

				if ( end ) {

					this.seconds = 0;
					this.setTimer( this.master, 0 );
				}
			}
		}

		/**
		 * Only pauses the timer but does not reset
		 * the master timer. If the timer is started
		 * again with start(), the timer will resume
		 * from where it stopped.
		 */
		public function pause():void
		{
			this.stop( false );
		}

		/**
		 * Sets the master timer to a timer that has
		 * already been added to the timer object
		 * with the addTimer() method.
		 */
		public function setMaster( name:String, seconds:uint ):void
		{
			if ( this.timerExists( name ) ) {

				this.master		= name;
				this.seconds	= seconds;

				this.setTimer( name, seconds );
			}
		}

		public function unSetMaster():void
		{
			this.master = null;
			this.seconds = 0;
		}

		/**
		 * Adds a timer to the _timer object. The timer will be
		 * synchronized with the other timers in _timer.
		 */
		public function addTimer( name:String, display:GameTimeDisplay ):void
		{
			if ( !this.timerExists( name ) ) {

				var timer:GameTimer = new GameTimer( name, display );
				_timer[ name ] = timer;
			}
		}

		public function removeTimer( name:String ):void
		{
			if ( this.timerExists( name ) ) {

				delete _timer[ name ];
			}
		}

		/**
		 * Sets an existing timer to a certain amount of
		 * seconds and sets the display.
		 */
		public function setTimer( name:String, seconds:uint ):void
		{
			if ( this.timerExists( name ) ) {

				var timer:GameTimer = _timer[ name ];
				timer.seconds = ( seconds > this.seconds ) ? this.seconds : seconds;
				timer.display.setTime( timer.seconds );
			}
		}

		/**
		 * Activates an existing timer. Required if a timer must
		 * start running after the master has been started.
		 */
		public function activateTimer( name:String ):void
		{
			if ( ( this.timer is Timer ) && ( this.timer.running ) ) {

				if ( this.timerExists( name ) ) {

					var timer:GameTimer = _timer[ name ];
					timer.active = true;
				}
			}
		}

		/**
		 * Deactivates an existing timer.
		 */
		public function deactivateTimer( name:String ):void
		{
			if ( this.timerExists( name ) ) {

				var timer:GameTimer = _timer[ name ];
				timer.active = false;
				timer.display.dispatchEvent( new GameEvent( GameEvent.TIMER_COMPLETE ) );
				TraceUtil.addLine( 'TimeManager deactivateTimer() >>> Timer deactivated: ' + timer.name );
			}
		}

		/**
		 * Adds a number of seconds to an existing timer. Seconds
		 * can be subtracted by passing a negative number.
		 */
		public function addSeconds( name:String, seconds:int ):void
		{
			if ( this.timerExists( name ) ) {

				var timer:GameTimer = _timer[ name ];
				timer.seconds += seconds;

				if ( timer.seconds < 0 ) {

					timer.seconds = 0;
				}

				// Processing for master timer
				if ( name == this.master ) {

					this.seconds = timer.seconds;

					// If seconds were added or subtracted from the master timer,
					// make sure none of the other timers have more seconds than
					// the master timer.
					for each ( var next:GameTimer in _timer ) {

						if ( next.name != this.master ) {

							if ( next.active && ( next.seconds > this.seconds ) ) {

								next.seconds = this.seconds;
								next.display.setTime( this.seconds );

								if ( next.seconds == 0 ) this.deactivateTimer( next.name );
							}
						}
					}

					if ( timer.seconds == 0 ) this.deactivateTimer( name );

				} else {

					if ( timer.seconds > this.seconds ) {

						timer.seconds = this.seconds;
					}
				}

				timer.display.setTime( timer.seconds );
			}
		}

		/**
		 * Checks if a timer exists.
		 */
		public function timerExists( name:String ):Boolean
		{
			if ( _timer.hasOwnProperty( name ) ) {

				//TraceUtil.addLine( 'TimeManager timerExists() >>> INFO: Timer ' + name + ' exists.' );
				return true;

			} else {

				//TraceUtil.addLine( 'TimeManager timerExists() >>> INFO: Timer ' + name + ' does not exist.' );
				return false;
			}
		}

		/**
		 * Checks if a timer is active.
		 */
		public function timerIsActive( name:String ):Boolean
		{
			if ( this.timerExists( name ) ) {

				var timer:GameTimer = _timer[ name ];
				return timer.active;

			} else {

				return false;
			}
		}

		/**
		 * Starts the master timer as an ActionScript Timer class object.
		 */
		private function startMasterTimer( delay:Number ):void
		{
			this.timer = new Timer( delay, 1 );
			this.timer.addEventListener( TimerEvent.TIMER, this.countDown );
			this.timer.start();
			this.startTime = getTimer();
		}

		private function stopMasterTimer():void
		{
			this.timer.removeEventListener( TimerEvent.TIMER, this.countDown );
			this.timer.stop();
		}

		private function activateTimers():void
		{
			for each ( var timer:GameTimer in _timer ) {

				if ( timer.seconds > 0 ) {

					timer.active = true;
				}
			}
		}

		/**
		 * Loops through all timers, decrements them
		 * and displays the result in the timer's
		 * display object.
		 */
		private function decrementTimers():void
		{
			for each ( var timer:GameTimer in _timer ) {

				if ( timer.active && ( timer.seconds > 0 ) ) {

					timer.seconds--;
					timer.display.setTime( timer.seconds );

					if ( timer.seconds == 0 ) {

						this.deactivateTimer( timer.name );
						TraceUtil.addLine( 'TimeManager decrementTimers() >>> Timer complete: ' + timer.name );
					}
				}
			}
		}

		/**
		 * Calculates how long it actually took the timer
		 * to time out and reduce the next delay by that
		 * amount. This allows the timer to proceed with
		 * a better overall accuracy, but the timer may
		 * seem to jump at times.
		 * 
		 * The returned delay will never be under 20ms,
		 * otherwise the frame rate would suffer.
		 */
		private function getDelay():Number
		{
			var currentTime:int	= getTimer();
			var elapsed:int		= currentTime - this.startTime;
			var overTime:int	= elapsed - TimeManager.MILLI_SECONDS;
			this.delay			-= overTime;

			if ( this.delay < 20 ) {

				this.delay = 20;
			}

			//TraceUtil.addLine( 'TimeManager getDelay() delay: ' + this.delay );

			return this.delay;
		}

		/**
		 * The countDown() method restarts the master timer
		 * every second. All timers are decremented by a second.
		 * The functionality uses getDelay() as a balancing
		 * method to ensure the timer actually takes as long
		 * as originally planned.
		 */
		private function countDown( event:Event ):void
		{
			this.stopMasterTimer();
			this.decrementTimers();

			this.seconds--;

			if ( this.seconds > 0 ) {

				this.startMasterTimer( this.getDelay() );
			}
		}
	}
}
