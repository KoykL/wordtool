events= require("events").EventEmitter
#require("../../lib/shuffle")
class processword extends events
	constructor: ()->
		
	process: (words, argv)->
		tmpwords = words
		if argv["argv"]["shuffle-words"]
			`Array.prototype.shuffle = function() {
				for (var j, x, i = this.length; i; j = parseInt(Math.random() * i), x = this[--i], this[i] = this[j], this[j] = x);
				return this;
			};`
			tmpwords.shuffle()
			#console.log("Now I emit")
			#@words = words
			@processed = true
			this.emit("end", tmpwords)
		else
			@processed = false
			this.emit("end", undefined)
		#return @words
	processed: ()->
		return @processed
exports.processword = processword