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
package com.bourre.commands 
{
	import com.bourre.collection.Iterable;
	
	/**
	 * <code>IterationCommand</code>s are used by a <code>LoopCommand</code> to perform
	 * the concret iterations. <code>IterationCommand</code> interface simply aggregate
	 * many other interfaces to ensure that all iteration commands should provides the
	 * same controls.
	 * <p>
	 * Concret implementations must consider each call of the <code>execute</code> method
	 * as loop iteration. All actions for a single elements must process in the call.
	 * </p>
	 * 
	 * @author	Cédric Néhémie
	 * @see		LoopCommand
	 * @see		../../../../docs/howto/howto-loopcommands.html How to use LoopCommand
	 * 			and IterationCommand
	 */
	public interface IterationCommand extends Iterable, Command
	{}
}
