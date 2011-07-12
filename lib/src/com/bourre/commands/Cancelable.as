package com.bourre.commands 
{

	/**
	 * <code>Cancelable</code> defines rules for <code>Runnable</code>
	 * implementations whose instances process could be cancelled.
	 * Implementers should consider the possibility for the user of the class
	 * to cancel or not the operation, if the operation could be cancelled,
	 * the implementer should create a <code>Cancelable</code> class.
	 * <p>
	 * More formally, an operation is cancelable if there is a need for the
	 * operation to abort during its process, or if the operation couldn't be
	 * paused(stopped) and resumed(re-started) without breaking the state of
	 * the process For example, a loading process could be stopped by an
	 * action of the user.  
	 * </p><p>
	 * Implementing the <code>Cancelable</code> interface doesn't require anything
	 * regarding the time outflow approach. The only requirements concerned the cancelable
	 * nature of the process. 
	 * </p><p>
	 * Note : There's no restriction concerning class which would implements both <code>Suspendable</code>
	 * and <code>Cancelable</code> interfaces.
	 * </p> 
	 * @author 	Cédric Néhémie
	 * @see		Runnable
	 * @see		Suspendable
	 */
	public interface Cancelable extends Runnable
	{
		/**
		 * Attempts to cancel execution of this task.
		 * This attempt will fail if the task has already completed,
		 * has already been cancelled, or could not be cancelled for
		 * some other reason. If successful, and this task has not
		 * started when cancel is called, this task should never run.
		 * <p>
		 * After this method returns, subsequent calls to <code>isRunning</code>
		 * will always return <code>false</code>. Subsequent calls to
		 * <code>run</code> will always fail with an exception. Subsequent
		 * calls to <code>isCancelled</code> will always failed with the throw
		 * of an exception. 
		 * </p>
		 * @throws 	<code>IllegalStateException</code> — if the <code>cancel</code>
		 * 			method have been called wheras the operation have been already
		 * 			cancelled
		 */
		function cancel() : void;
		
		/**
		 * Returns <code>true</code> if the operation have been stopped
		 * as a result of a <code>cancel</code> call.
		 * 
		 * @return	<code>true</code> if the operation have been stopped
		 * 			as a result of a <code>cancel</code> call
		 */
		function isCancelled () : Boolean;
	}
}
