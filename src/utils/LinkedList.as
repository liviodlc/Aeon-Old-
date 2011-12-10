package utils {

    /**
     * LinkedList with built-in iterator.
     */
    public class LinkedList {

        // Elements of the linked list
        private var head:Node;
        private var iterator:Node;

        /**
         *  No arg constructor for linked list. Initializes
         *  all var to null.
         * 
         */
        public function LinkedList() {

            // Initializing to null
            head = null;
            iterator = null;

        }

        /**
         *  Checking if list is empty.
         */
        public function isEmpty(): Boolean {

            // null head is an empty list
            return head == null;

        }

        /**
         * Checking if there are more elements in the list.
         */
        public function hasNext(): Boolean {

            // null iterator is done with list
            return iterator != null;

        }

        /**
         *  Getting next item in list.
         */
        public function get next(): Object {

            var n:Object = iterator.object;

            iterator = iterator.next;

            return n;

        }

        /**
         * Resetting iteration to beginning of list.
         */
        public function beginIteration(): void {

            // reset to head
            iterator = head;

        }

        /**
         * Removing all elements from list
         */
        public function clear(): void {

            // Remove all objects from list
            iterator = head;

            while( iterator != null ) {
                iterator = iterator.next;
                head = iterator;
            }

        }

        /**
         * Add object to list. Insert at head.
         */
        public function add( toAdd:Object ):void {

            // addition become new head
            head = new Node( toAdd, head );

        }

    }

}

/**
 * Node elements of list above. Stores next node
 * and current node object.
 */
internal class Node {

    // Elements of a node
    private var obj:Object;
    private var nex:Node;

    /**
     * Node constructor. Define object and node next
     */
    public function Node( o:Object, n:Node ) {

        obj = o;
        nex = n;

    }

    /**
     * Get next node in list.
     */
    public function get next():Node {

        return nex;

    }

    /**
     * Get current node's stored object.
     */
    public function get object():Object {

        return obj;

    }

}
