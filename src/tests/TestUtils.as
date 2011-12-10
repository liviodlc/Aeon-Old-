package tests
{
	import utils.LinkedList;
	
	public class TestUtils
	{
		public function TestUtils()
		{
			
			testLinkedLists();
			
		}
		
		private function testLinkedLists():void {
			
			var test:LinkedList;
			
			test = new LinkedList();
			
			Test.AssertTrue( test.isEmpty() );
			Test.AssertTrue( !test.hasNext() );
			
			test.add( true );
			test.add( 1 );
			test.add( 3.14 );
			
			test.beginIteration();
			Test.AssertTrue( test.next == 3.14 );
			Test.AssertTrue( test.next == 1 );
			Test.AssertTrue( test.next == true );
			
			test.beginIteration();
			
			while( test.hasNext() ) {
				
				trace( test.next );
				
			}
			
		}
		
	}
}
