// DEFINING OBJECT IDs
var $default_objects:XML = new XML('<xml><objects>' +
	'<obj id="x" name="Indestructible Crate" />' +
	'<obj id="#" behavior="player" name="Player" />' +
	'<obj id="H" name="Wooden Ladder" />' +
	'<obj id="h" inheritsFrom="H" name="Rope Ladder" />' +
	'<obj id="-" name="Platform" />' +
	'<obj id="_" name="Upside-down Platform" />' +
	'<obj id="k" name="Falling Crate" />' +
	'<obj id="b" name="Bounce Crate" />' +
	'<obj id="g" name="Super Bounce Crate" />' +
	'<obj id="~" name="Water" />' +
'</objects></xml>');

// DEFINING OBJECT STYLES
var $default_styles:XML = new XML("<xml><styles><![CDATA[" +
"x {" +
	"init-state: static;" +
	"allow-state-change: false;" +
	"hitbox-size: 32 32;" +
	"coll-edge-solidity: solid-wall;" +
	"coll-edge-buffer: 0 5;" +
	"animate: indy;" +
	"z-index: front;" +
"}" +
"H {" +
	"init-state: static;" +
	"allow-state-change: false;" +
	"hitbox-size: 32 32;" +
	"coll-edge-solidity: solid-ladder;" +
	"coll-effect-ladder: true;" +
	"animate: ladder_wood;" +
	"z-index: back;" +
"}" +
"h {" +
	"animate: ladder_rope;" +
"}" +
"- {" +
	"hitbox-size: 32 16;" +
	"coll-edge-top-solidity: solid-wall;" +
	"animate: platform-top;" +
"}" +
"_ {" +
	"hitbox-size: 32 16;" +
	"hitbox-offset-y: 16;" +
	"coll-edge-bottom-solidity: solid-wall;" +
	"animate: platform-bottom;" +
"}" +
"k {" +
	"init-state:static;" +
	"allow-state-change: false;" +
	"hitbox-size: 32;" +
	"hitbox-offset-x: 0;" +
	"coll-edge-solidity: solid-wall;" +
	"coll-edge-buffer: 0 5;" +
	"accelerate-y: 1;" +
	"max-speed-y: 10;" +
	"animate: light-steel;" +
"}" +
"k:standing-on-up {" +
	"hitbox-offset-x: -32;" +
	"hitbox-width: 96;" +
	"animate: light-steel2;" +
"}" +
"b {" +
	"init-state:static;" +
	"allow-state-change: false;" +
	"hitbox-size: 32;" +
	"coll-edge-solidity: solid-wall;" +
	"coll-edge-buffer: 0 5;" +
	"coll-edge-bounce: 20;" +
	"animate: wooden-crate;" +
"}" +
"g {" +
	"init-state:static;" +
	"allow-state-change: false;" +
	"hitbox-size: 32;" +
	"coll-edge-solidity: solid-wall;" +
	"coll-edge-buffer: 0 5;" +
	"coll-edge-bounce: 36;" +
	"animate: gem;" +
"}" +
"~ {" +
	"init-state:static;" +
	"allow-state-change:false;" +
	"hitbox-size: 928 256;" +
	"coll-effect-water:true;" +
	"animate: water;" +
"}" +
"# {" +
	"init-state: nonstatic;" +
	"allow-state-change: false;" +
	"animate: gerbil;" +
	"z-index: back;" +
	"hitbox-size: 26 38;" +
	"hitbox-offset: 3 -5;" +
	"coll-edge-solidity: solid-wall;" +
	"can-use-ladder: true;" +
	"allow-jump: false;" +
	"friction-x: 2;" +
	"accelerate-x: 0;" +
	"accelerate-y: 2;" +
	"max-speed-x: 10;" +
	"max-speed-down: 20;" +
	"max-speed-up:9001;" +
"}" +
"#:standing-on-down{" +
	"allow-jump: true;" +
"}" +
"#:face-left{" +
	"animate: gerbil2;" +
"}" +
"#:right {" +
	"accelerate-x: 3;" +
	"animate: gerbil-right1;" +
"}" +
"#:left {" +
	"accelerate-x: -3;" +
	"animate: gerbil-left1;" +
"}" +
"#:jump {" +
	"set-speed-y: -22;" +
"}" +
"#:jump:right{" +
	"set-speed-x: 10" +
"}" +
"#:jump:left{" +
	"set-speed-x: -10;" +
"}" +
"#:ladder {" +
	"accelerate-y: 0;" +
	"friction: 5;" +
	"max-speed: 5;" +
"}" +
"#:water {" +
	"accelerate-y: -0.25;" +
	"max-speed: 9001 8 8 8;" +
	"allow-jump: true;" +
	"friction: 2;" +
"}" +
"#:water:jump{" +
	"set-speed-y: -12;" +
"}" +
"#:ladder:up, #:water:up{" +
	"accelerate-y: -1.5;" +
"}" +
"#:ladder:down, #:water:down{" +
	"accelerate-y: 1.5;" +
"}" +
"#:ladder:right, #:water:right{" +
	"accelerate-x: 1.5;" +
"}" +
"#:ladder:left, #:water:left{" +
	"accelerate-x: -1.5;" +
"}" +
"]]></styles></xml>");