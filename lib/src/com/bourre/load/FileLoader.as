package com.bourre.load {
	import com.bourre.load.strategy.URLLoaderStrategy;	

	public class FileLoader extends AbstractLoader
	{
		public function FileLoader(url : String = null)
		{
			super( new URLLoaderStrategy());
		}
	}
}