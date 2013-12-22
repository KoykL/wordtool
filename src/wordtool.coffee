optimist = require('optimist')
path = require("path")
wordloader = require('./wordloader').wordloader
wordprocessor = require("./wordprocessor/main").wordprocessor
outputter = require("./outputter").outputter
fs = require("fs")
checkforseparateddefinition = (arg) ->
	#console.log(arg)
	if arg._.length < 1
		throw "You need to specify the file(s) that contain words and is(are) needed to be processed.\n"
	else return true
checkforspecifiedfile = (arg) ->
	#console.log(arg)
	if arg["separated-definition"] && !arg["with-definition"]
		throw 'You cannot enable "separated-definition" without enable "with-definition" first.'
	else return true
argv = optimist
	.usage("A handy tool helps you to deal with new words.\n\nUsage: $0 [options] [start file number]-[end file number]\nYou can use --no-[option] to disable an option if it is enabled by default.\n")
	.boolean("with-index")
	.describe("with-index", "Give each word an index number.")
	.boolean("strip-comments")
	.describe("strip-comments", "Strip away comments after #.")
	.boolean("shuffle-words",)
	.describe("shuffle-words", "Output words into random order.")
	.boolean("with-definition")
	.describe("with-definition", "Search iciba and append definition after each word.")
	.boolean("separated-definition")
	.describe("separated-definition", "Put definitions into a individual file")
	.option("avoid-redundancy",
		alias: "r"
		default: true
	)
	.describe("avoid-redundancy", "Strip away redundant words")
	.boolean("avoid-redundancy")
	.boolean("help")
	.alias("help", "h")
	.default("help", false)
	.describe("help", "Print out this help.")
	.alias("outputdir", "o")
	.default("outputdir", "./")
	.describe("outputdir", "Specify the output directory. This defaults to inputdir when not being specified.")
	.alias("inputdir", "e")
	.default("inputdir", "./")
	.describe("inputdir", "Specify where to search for input file.")
	.option("debug",
		alias: "b"
		default: false
	)
	.boolean("debug")
	.describe("debug", "Enable verbose output")
	.option("with-index",
			alias: "i"
			default: true
			)
	.option("strip-comments",
			alias: "c"
			default: false
			)
	.option("shuffle-words",
			alias: "s"
			default: false
			)
	.option("with-definition",
			alias: "d"
			default: false
			)
	.option("separated-definition",
			alias: "p"
			default: false
			)
	.check(checkforseparateddefinition)
	.check(checkforspecifiedfile)
	.argv
option = 
	argv: argv
filewithext=[]
for file in argv._
	pos1 = file.indexOf("-")
	startfile = parseInt(file.slice(0, pos1))
	endfile = parseInt(file.slice(pos1+1))
	while startfile <= endfile
		filewithext.push("#{startfile}.txt")
		startfile++
	#console.log(filewithext)
option["inputfile"] =  "#{argv._.join()}.txt"
inputdir = argv.inputdir
inputdir += "/"
inputdir = path.normalize(inputdir)
mp=new wordloader("#{inputdir}#{file}" for file in filewithext)
mp.on("end", (data) ->
	#console.log(data)
	words=[]
	for eachword, i in data
		words[i] = new Object()
		words[i]["name"] = eachword
	if argv.debug
		console.log("raw: ")
		console.log(words)
	wp = new wordprocessor()
	wp.on("end", ()->
		if argv.debug
			console.log("Word processor result:")
			console.log(wp.getresult())
			fs.writeFileSync("debug-data", JSON.stringify(wp.getresult()), "utf8")
		if option["argv"]["outputdir"] == "./"
			option["argv"]["outputdir"] = option["argv"]["inputdir"]
		output = new outputter()
		output.on("end", (x)->
			console.log(x)
		)
		output.process(wp.getresult(), option)
	)
	wp.process(words, option)
	
)
	
		