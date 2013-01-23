events= require("events").EventEmitter
class processword extends events
	constructor: ()->
	#getresult: ()->
		#return @words
	process: (words, argv)->
		if argv["argv"]["strip-comments"]
			#@words = words
			#processedwords = stripcomments(@words)
			#for each, i in @words
				#each["name"] = processedwords[i]
			#if argv.debug
				#console.log("Strip comments: words:")
				#console.log(words)
			#console.log("Now I emit")
			processedwords = stripcomments(words)
			#words.splice(0)
			#for each in processedwords
			#	words.push(each)
			#for each, i in words
				#each["name"] = processedwords[i]
			@processed = true
			#argv["stripedcomments"] = true
			this.emit("end", processedwords)	
		else
			@processed = false
			this.emit("end", undefined)	
	processed: ()->
		return @processed
stripcomments = (words) ->
	tmpholder = []
	tmpholder2 = words
	#console.log(words)
	for eachobject in tmpholder2
		each = eachobject["name"]
		pos = each.indexOf("#")
		wordhaventstrippedblanks = if pos >= 0 then each.slice(0, pos) else each
		reg = /[^ \t].*[^ \t]/g
		#posspace = wordhaventstrippedblanks.indexOf(" ")
		#wordsstrippedspace = if posspace >= 0 then wordhaventstrippedblanks.slice(0, posspace) else wordhaventstrippedblanks
		#postab = wordsstrippedspace.indexOf("\t")
		#worddone = if postab >= 0 then wordsstrippedspace.slice(0, postab) else wordsstrippedspace
		worddone = wordhaventstrippedblanks.match(reg)
		if worddone and worddone.length isnt 0
			eachobject["name"] = worddone[0]
			tmpholder.push(eachobject)
			#console.log(eachobject)
	return tmpholder
exports.processword = processword
exports.stripcomments = stripcomments