package tests {
	import org.interguild.utils.OrderedList;

	public class TestOrderedList {

		public function TestOrderedList() {
			var ol:OrderedList = new OrderedList();

			//test ordered inserts
			ol.add(new Stuff(10));
			ol.add(new Stuff(20));
			ol.add(new Stuff(30));
			Test.AssertEquals(Stuff(ol.get(0)).num, 10);
			Test.AssertEquals(Stuff(ol.get(1)).num, 20);
			Test.AssertEquals(Stuff(ol.get(2)).num, 30);

			//test left-extreme insert
			ol.add(new Stuff(5));
			Test.AssertEquals(Stuff(ol.get(0)).num, 5);
			Test.AssertEquals(Stuff(ol.get(1)).num, 10);
			Test.AssertEquals(Stuff(ol.get(2)).num, 20);
			Test.AssertEquals(Stuff(ol.get(3)).num, 30);

			//test insert at index 1
			ol.add(new Stuff(7));
			Test.AssertEquals(Stuff(ol.get(0)).num, 5);
			Test.AssertEquals(Stuff(ol.get(1)).num, 7);
			Test.AssertEquals(Stuff(ol.get(2)).num, 10);
			Test.AssertEquals(Stuff(ol.get(3)).num, 20);
			Test.AssertEquals(Stuff(ol.get(4)).num, 30);

			//test insert at index 2
			ol.add(new Stuff(8));
			Test.AssertEquals(Stuff(ol.get(0)).num, 5);
			Test.AssertEquals(Stuff(ol.get(1)).num, 7);
			Test.AssertEquals(Stuff(ol.get(2)).num, 8);
			Test.AssertEquals(Stuff(ol.get(3)).num, 10);
			Test.AssertEquals(Stuff(ol.get(4)).num, 20);
			Test.AssertEquals(Stuff(ol.get(5)).num, 30);

			//test insert at index n-2
			ol.add(new Stuff(25));
			Test.AssertEquals(Stuff(ol.get(0)).num, 5);
			Test.AssertEquals(Stuff(ol.get(1)).num, 7);
			Test.AssertEquals(Stuff(ol.get(2)).num, 8);
			Test.AssertEquals(Stuff(ol.get(3)).num, 10);
			Test.AssertEquals(Stuff(ol.get(4)).num, 20);
			Test.AssertEquals(Stuff(ol.get(5)).num, 25);
			Test.AssertEquals(Stuff(ol.get(6)).num, 30);

			//test insert double not equal
			ol.add(new Stuff(10, 1));
			Test.AssertEquals(Stuff(ol.get(0)).num, 5);
			Test.AssertEquals(Stuff(ol.get(1)).num, 7);
			Test.AssertEquals(Stuff(ol.get(2)).num, 8);
			Test.AssertEquals(Stuff(ol.get(3)).num, 10);
			Test.AssertEquals(Stuff(ol.get(3)).mim, 0);
			Test.AssertEquals(Stuff(ol.get(4)).num, 10);
			Test.AssertEquals(Stuff(ol.get(4)).mim, 1);
			Test.AssertEquals(Stuff(ol.get(5)).num, 20);
			Test.AssertEquals(Stuff(ol.get(6)).num, 25);
			Test.AssertEquals(Stuff(ol.get(7)).num, 30);
			
			//test insert double equal
			ol.add(new Stuff(10, 1));
			Test.AssertEquals(Stuff(ol.get(0)).num, 5);
			Test.AssertEquals(Stuff(ol.get(1)).num, 7);
			Test.AssertEquals(Stuff(ol.get(2)).num, 8);
			Test.AssertEquals(Stuff(ol.get(3)).num, 10);
			Test.AssertEquals(Stuff(ol.get(3)).mim, 0);
			Test.AssertEquals(Stuff(ol.get(4)).num, 10);
			Test.AssertEquals(Stuff(ol.get(4)).mim, 1);
			Test.AssertEquals(Stuff(ol.get(5)).num, 20);
			Test.AssertEquals(Stuff(ol.get(6)).num, 25);
			Test.AssertEquals(Stuff(ol.get(7)).num, 30);
			
			//test insert double not equal again
			ol.add(new Stuff(10, 3));
			Test.AssertEquals(Stuff(ol.get(0)).num, 5);
			Test.AssertEquals(Stuff(ol.get(1)).num, 7);
			Test.AssertEquals(Stuff(ol.get(2)).num, 8);
			Test.AssertEquals(Stuff(ol.get(3)).num, 10);
			Test.AssertEquals(Stuff(ol.get(3)).mim, 0);
			Test.AssertEquals(Stuff(ol.get(4)).num, 10);
			Test.AssertEquals(Stuff(ol.get(4)).mim, 1);
			Test.AssertEquals(Stuff(ol.get(5)).num, 10);
			Test.AssertEquals(Stuff(ol.get(5)).mim, 3);
			Test.AssertEquals(Stuff(ol.get(6)).num, 20);
			Test.AssertEquals(Stuff(ol.get(7)).num, 25);
			Test.AssertEquals(Stuff(ol.get(8)).num, 30);
		}
	}
}
import org.interguild.utils.Comparable;

internal class Stuff implements Comparable {

	private var n:uint;
	private var m:uint;


	public function Stuff(n:uint, m:uint = 0) {
		this.n = n;
		this.m = m;
	}


	public function compareTo(other:Comparable):int {
		var that:Stuff = Stuff(other);
		if (this.equals(that))
			return int.MIN_VALUE;
		return this.n - that.n;
	}


	private function equals(other:Stuff):Boolean {
		if (this.m > 0 && other.m > 0)
			return (this.m == other.m && this.n == other.n);
		else
			return false;
	}


	public function get num():uint {
		return n;
	}


	public function get mim():uint {
		return m;
	}
}
