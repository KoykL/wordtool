events= require("events").EventEmitter
class processword extends events
	constructor: ()->
	#getresult: ()->
		#return @words
	process: (words, argv)->
		if argv["strip-comments"]
			#@words = words
			#processedwords = stripcomments(@words)
			#for each, i in @words
				#each["name"] = processedwords[i]
			#if argv.debug
				#console.log("Strip comments: words:")
				#console.log(words)
			#console.log("Now I emit")
			processedwords = stripcomments(words)
			for each, i in words
				each["name"] = processedwords[i]
			@processed = true
		else
			@processed = false
		this.emit("end")		
	processed: ()->
		return @processed
stripcomments = (words) ->
	tmpholder = []
	for eachobject in words
		each = eachobject["name"]
		pos = each.indexOf("#")
		wordhaventstrippedblanks = if pos >= 0 then each.slice(0, pos) else each
		posspace = wordhaventstrippedblanks.indexOf(" ")
		wordsstrippedspace = if posspace >= 0 then wordhaventstrippedblanks.slice(0, posspace) else wordhaventstrippedblanks
		postab = wordsstrippedspace.indexOf("\t")
		worddone = if postab >= 0 then wordsstrippedspace.slice(0, postab) else wordsstrippedspace
		if worddone.length isnt 0
			tmpholder.push(worddone)
	return tmpholder
exports.processword = processword
exports.stripcomments = stripcomments