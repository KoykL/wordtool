fs = require("fs")
path = require("path")
events= require("events").EventEmitter
class wordprocessor extends events
	words = ""
	scriptcount = 0
	constructor: () ->
	process: (wordsinput, argv)->
		@words = wordsinput
		plugindir = fs.readdirSync("#{__dirname}/plugins")
		plugins = (plugin for plugin in plugindir when plugin.slice(-3) is ".js")
		@scriptcount = 0
		that = this
		#this.emit("end")
		for plugin in plugins
			if argv["argv"].debug
				console.log("Calling plugin #{path.join(__dirname, 'plugins', plugin)}")
			processword = require("#{path.join(__dirname, 'plugins', plugin)}").processword
			pr = new processword()
			#this.emit("end")
			pr.on("end", (data)->
				#if argv["argv"].debug
					#console.log("data returned on call back:")
				#console.log(data)
				if data isnt undefined
					#console.log("returned")
					
					that.words = data
					#console.log(data)
				that.scriptcount++
				that.emit("end") if that.scriptcount is plugins.length
				)
			tmpwords = @words
			#console.log(words)
			pr.process(tmpwords, argv)
			#@words = pr.words
	getresult: ()->
		#console.log("reached")
		return @words
exports.wordprocessor = wordprocessor