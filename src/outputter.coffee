events= require("events").EventEmitter
fs = require("fs")
path = require("path")
getPlatformEOL = () ->
    if process.platform is "win32" then "\r\n" else "\n";

class outputter extends events
	constructor: ()->
	#getresult: ()->
		#return @words
	process: (words, option)->
		tmpwords = words
		chineseoutput = "None"
		if option["argv"]["shuffle-words"]
			outputfile =  "s#{option['inputfile']}"
		else 
			outputfile = "#{option['inputfile']}"
		#deciding whether I am writing out shuffled word
		output = path.join(option["argv"]["outputdir"], outputfile)
		if option["argv"]["separated-definition"]
			chineseoutputfile = "c#{outputfile}"
			chineseoutput = path.join(option["argv"]["outputdir"], chineseoutputfile)
		#giving separated chinese output its name
		if option["argv"]["with-index"]
			for each, i in tmpwords
				each["index"] = i
		#(dirty hack!!) giving words their index
		fs.writeFileSync(output, "") 
		#in case when file doesnt exist
		if option["argv"]["separated-definition"]
			fs.writeFileSync("#{chineseoutput}", "")  
			chineseoutput = "#{chineseoutput}"
		#in case when the chinese file doesnt exist
		for each in tmpwords
			sum = ""
			if each["index"] isnt undefined
				sum += each["index"]
				sum += ":"
				sum += " " #add indentation
			#add index
			sum += each["name"]
			#add word itself
			if each["definition"] && not option["argv"]["separated-definition"]
				sum += " " #add indentation
				sum += each["definition"]
			fs.appendFileSync(output, "#{sum}#{getPlatformEOL()}")
			#Really write out
			if option["argv"]["separated-definition"]
				if option["argv"]["with-index"]
					fs.appendFileSync(chineseoutput, "#{each.index}: #{each.definition}#{getPlatformEOL()}")
				else
					fs.appendFileSync(chineseoutput, "#{each.definition}#{getPlatformEOL()}")
			#Writing out chinese definition. Quite Simple. Do not need to explain.
		this.emit("end", "#{output} #{chineseoutput}")
		#The file that I've written into.
exports.outputter	= outputter