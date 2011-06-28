package com.bourre.commands
{
	public interface MacroCommand extends Command
	{
		function addCommand( oCommand : Command ) : Boolean;
		function removeCommand( oCommand : Command ) : Boolean;
	}
}