fs = require('fs')
path = require("path")
ll = require("lazylines")
events = require("events")
class wordloader extends events.EventEmitter
	constructor: (wordpath, files) ->
		#filesunderpath = fs.readdirSync(path)
		#filewithword =��file for file in filesunderpath when /.+\.txt/file
		@texts = []
		count=0
		@endcount = 0
		tmpholder = []
		that = this
		for file in files
			fd = fs.createReadStream("#{wordpath}#{file}", 
									flags: 'r'
									encodeing: "utf8"
									fd: null
									mode: 666
									bufferSize: 64 * 1024) 
			inp = new ll.LineReadStream(fd, "utf8")
			tmpholder[count] = new Array()
			callbackfunction = undefined
			eval("""callbackfunction = function (data){
					tmpholder[#{count}].push(ll.chomp(data))
					/*console.log(data)*/
					}
				""")	
			inp.on("line", callbackfunction)
			count++
			inp.on("end", ()->
						if that.endcount >= files.length - 1
							for tmp in tmpholder
								for word in tmp
									that.texts.push(word)
							that.emit("end", that.texts) 
							#console.log("reached")
						#console.log(tmpholder)
						that.endcount++
					)
		
		#fd.setEncoding("utf8") for fd in fds
		#for fd in fds:
			
			
		#tmpholder = []

		
		#count = 0
		#for inp in inps
			#tmpholder[count] = new Array()
			#internalcounter=count;tmpholder[internalcounter].push(ll.chomp(line))) 
			#inp.on("line", (line) -> console.log(ll.chomp(line)))
			#count++;
		
		#console.log(tmpholder[0][0])
		#@text.push(word) for word in tmpholderitem for tmpholderitem in tmpholder

		#@texts = (fs.readFileSync("#{wordpath}#{file}", "utf-8") for file in files)
	getwords: ()->
		return @texts
exports.wordloader = wordloader