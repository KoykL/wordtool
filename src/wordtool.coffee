optimist = require('./optimist/index')
path = require("path")
wordloader = require('./wordloader').wordloader
wordprocessor = require("./wordprocessor/main").wordprocessor
outputter = require("./outputter/outputter").outputter
class checkforseparateddefinition 
	call: (arg) ->
	#console.log(arg)
		if arg["separated-definition"] && !arg["with-definition"]
			return false
		else return true
	toString: ()->
		'You cannot enable "separated-definition" without enable "with-definition" first.'
argv = optimist
	.usage("A handy tool helps you to deal with new words.\nUsage: $0")
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
	.boolean("help")
	.alias("help", "h")
	.default("help", false)
	.describe("help", "Print out this help.")
	.alias("outputdir", "o")
	.default("outputdir", "")
	.describe("outputdir", "Specify the output directory.")
	.alias("inputdir", "e")
	.default("inputdir", "./")
	.describe("inputdir", "Specify where to search for input file.")
	.boolean("debug")
	.describe("debug", "Enable verbose output")
	.option("with-index",
			alias: "i"
			default: false
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
	.option("debug",
		alias: "b"
		default: false
	)
	.string("data")
	.default("data", "data")
	.describe("data", "Specify where the data file.")
	.check(new checkforseparateddefinition)
	.argv
option = 
	argv: argv
if argv._.length < 1
	if argv.help
		console.log(optimist.help())
	else
		console.log("You need to specify the file(s) that contain words and is(are) needed to be processed.\n\n#{optimist.help()}")
filewithext=[]
for file in argv._
	pos1 = file.indexOf("-")
	startfile = parseInt(file.slice(0, pos1))
	endfile = parseInt(file.slice(pos1+1))
	while startfile <= endfile
		filewithext.push("#{startfile}.txt")
		startfile++
	#console.log(filewithext)
option["inputfile"] =  "#{argv._}.txt"
inputdir = argv.inputdir
inputdir += "/"
inputdir = path.normalize(inputdir)
#console.log(inputdir)
mp=new wordloader(inputdir, filewithext)
mp.on("end", (data) ->
	#console.log(data)
	words=[]
	for eachword, i in data
		words[i] = new Object()
		words[i]["name"] = eachword
	wp = new wordprocessor()
	wp.on("end", ()->
		if argv.debug
			console.log("Word processor result:")
			console.log(wp.getresult())
		output = new outputter()
		output.on("end", (x)->
			console.log(x)
		)
		output.process(wp.getresult(), option)
	)
	wp.process(words, option)
	
)
	
		