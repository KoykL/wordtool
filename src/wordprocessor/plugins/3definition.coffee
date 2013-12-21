events= require("events").EventEmitter
xml = require("xml2js")
http = require('http')
stripcomments = require("./1stripcomments")
class processword extends events
	constructor: ()->
	process: (iwords, argv)->
		if argv["argv"]["with-definition"]
			if not argv["stripedcomments"]
				words = stripcomments.stripcomments(iwords)
			for each, i in words
				words[i]["name"] = each["name"].toLocaleLowerCase()
			referencetable = flattern(words)
			words2 = iwords
			#console.log(words)
			tmpwords = []
			counter = 0
			that = this
			parser = new xml.Parser()
			parser.on("end", (result)->
				sum = ""
				#console.log(result)
				definition = result["dict"]["acceptation"]
				pos = result["dict"]["pos"]
				if definition and pos isnt undefined
					for each, i in definition
						if typeof(pos[i]) is "string"
							sum += pos[i].replace(/^\s*|\s*$/g, "")
						sum += each.replace(/^\s*|\s*$/g, "")
				else sum = "Unknown"
				key = result["dict"]["key"][0]
				object = referencetable[key]
				object["definition"] = sum
				counter++
				#console.log(words.length)
				if counter is words.length
					for each in words2
						each["definition"] = referencetable[each["name"]]["definition"]
						tmpwords.push(each)
					that.emit("end", tmpwords)
				#console.log(object)
				)
			for each in words
				word = each.name
				options =
						host: 'dict-co.iciba.com',
						port: 80,
						path: "/api/dictionary.php?w=#{word}&key=01C57073FFB5472B45411DF15B827A11"
						
				http.get(options, (res)->
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