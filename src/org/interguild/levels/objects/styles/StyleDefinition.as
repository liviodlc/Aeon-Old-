package org.interguild.levels.objects.styles {
	import utils.LinkedList;

	public class StyleDefinition {
		
		private var pseudoConditions:PseudoClassTriggers;
		private var dynamicConditions:DynamicTriggers;
		private var rules:LinkedList;

		public function StyleDefinition(p:PseudoClassTriggers, d:DynamicTriggers, r:LinkedList) {
			pseudoConditions = p;
			dynamicConditions = d;
			rules = r;
		}
		
		public function get isDynamic():Boolean{
			return !dynamicConditions.isEmpty();
		}
	}
}
