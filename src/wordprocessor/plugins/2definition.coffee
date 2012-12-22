events= require("events").EventEmitter
xml = require("xml2js")
http = require('http')
stripcomments = require("./0stripcomments")
class processword extends events
	constructor: ()->
	process: (words, argv)->
		if argv["argv"]["with-definition"]
			if not argv["stripedcomments"]
				words = stripcomments.stripcomments(words)
			referencetable = flattern(words)
			#console.log(words)
			tmpwords = []
			counter = 0
			that = this
			parser = new xml.Parser()
			parser.on("end", (result)->
				sum = ""
				#console.log(result)
				definition = result["dict"]["acceptation"]
				if definition isnt undefined
					for each in definition
						sum += each.match(/[^\n].*[^\n]/)
				else sum += "Unknown"
				key = result["dict"]["key"][0]
				object = referencetable[key]
				object["definition"] = sum
				tmpwords.push(object)
				counter++
				#console.log(words.length)
				if counter is words.length
					that.emit("end", tmpwords)
				#console.log(object)
				)
			for each in words
				word = each.name
				http.get("http://dict-co.iciba.com/api/dictionary.php?w=#{word}", (res)->
					res.setEncoding("utf8")
					res.on("data", (data)->
						parser.parseString(data)
					)
				)
			@processed = true	
		else
			@emit("end", undefined)
			@processed = false
	processed: ()->
		return @processed
flattern = (words)->
	tmpholder = {}
	for each in words
		tmpholder[each["name"]] = each
	return tmpholder
exports.processword = processword