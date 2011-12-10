package tests {
	
	public class Test {
		
		public static function AssertTrue( check:Boolean ):void  {
			
			if( !check ) 
				throw new Error("Assertion failed");
			
			trace( "Assertion passed." );
			
		}
		
	}
}