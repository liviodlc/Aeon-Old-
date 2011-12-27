package org.interguild.utils {

	public class OrderedList {

		private var a:Array;


		public function OrderedList() {
			a = []; //initialize array
		}


		/**
		 * Returns the element at the specified index.
		 */
		public function get(i:uint):Comparable {
			return a[i];
		}


		/**
		 * Returns the length of the OrderedList.
		 */
		public function get length():uint {
			return a.length;
		}


		/**
		 * Adds the object to the correct position in the array maintaining order
		 */
		public function add(o:Comparable):void {
			if (a.length == 0) {
				a.push(o);
			} else {
				var first:int, last:int, mid:int, compare:int;
				last = a.length - 1;
				while (first <= last) {
					mid = (first + last) / 2;
					compare = o.compareTo(Comparable(a[mid]));
					if (compare == int.MIN_VALUE) {
						return; // cancel insertion
					} else if (compare > 0) {
						if (first == last) {
							addAt(o, first + 1);
							return;
						} else {
							first = mid + 1;
						}
					} else if (compare < 0) {
						if (first == last) {
							addAt(o, first);
							return;
						} else {
							last = mid;
						}
					} else {
						var p:int = lastOfSequence(o, mid);
						if (p != -1)
							addAt(o, p);
						return;
					}

				}
			}
		}


		/**
		 * When there are many elements of the same weight, we want the newest element
		 * to be added at the farthest-right position possible. So this function finds
		 * the very last element of a sequence of equal-weighted elements starting at
		 * index i, and returns the index at which a new element of equal weight may
		 * be added to the array.
		 *
		 * This function assumes that o.compareTo(a[i])==0
		 */
		private function lastOfSequence(o:Comparable, i:uint):int {
			i++;
			while (a[i] != null) {
				var compare:int = o.compareTo(a[i]);
				if (compare == int.MIN_VALUE)
					return -1;
				if (compare != 0)
					return i;
				i++;
			}
			return i;

		}


		/**
		 * Adds the element to the array at the specified position, while shifting
		 * everything after that to the right by one position.
		 */
		private function addAt(el:Comparable, pos:uint):void {
			a.push(null); //add one to array length
			for (var i:int = a.length - 2; i >= pos; i--)
				a[i + 1] = a[i];
			a[pos] = el; // i == pos
		}
	}
}
