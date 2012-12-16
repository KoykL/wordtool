events= require("events").EventEmitter
#require("../../lib/shuffle")
class processword extends events
	constructor: ()->
		
	process: (words, argv)->
		if argv["shuffle-words"]
			`Array.prototype.shuffle = function() {
				for (var j, x, i = this.length; i; j = parseInt(Math.random() * i), x = this[--i], this[i] = this[j], this[j] = x);
				return this;
			};`
			words.shuffle()
			#console.log("Now I emit")
			#@words = words
			@processed = true
		else
			@processed = false
		this.emit("end")
		#return @words
	processed: ()->
		return @processed
exports.processword = processword