events= require("events").EventEmitter
class processword extends events
	constructor: ()->
	process: (words, options)->
		existed = undefined
		tmpholder = undefined
		if options["argv"]["avoid-redundancy"]
			existed = new Object()
			tmpholder = new Array()
			for each in words
				if not existed[each["name"]]
					existed[each["name"]] = true
					tmpholder.push(each)
		@emit("end", tmpholder)
	processed: ()->
		return @processed
exports.processword = processword