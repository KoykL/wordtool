events= require("events").EventEmitter
fs = require('fs')
class quizpersistence extends events
	constructor: ()->
	
	process: (words, option)->
		tmpholder = {}
		