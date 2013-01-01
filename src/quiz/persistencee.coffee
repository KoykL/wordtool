fs = require ("fs")
loadJSON = (datafile)->
	rawJSON = fs.readFileSync(datafile, "utf8")
	parsedobject = JSON.parse(rawJSON)
	return parsedobject
writeJSON = (datafile, data) ->
	rawJSON = JSON.stringify(data)
	fs.writeFileSync(datafile, rawJSON, "utf8")
writedata = (words, option) ->
	datafile = option.argv["data"]
		if fs.existsSync(datafile)
			object = loadJSON(datafile)
		else
			object = new Object()
		object[option["date"]] = new Object()
		object[option["date"]]["name"] = option["name"]
		object[option["date"]]["words"] = words
		writeJSON(object)
readdata = (dates, names, option) ->
	#dates and names are lists
	object = loadJSON(option.argv["data"])
	rawwords = []
	tmpholder = []
	for date in dates
		for word in object[date]
			rawwords.push(word)
	for word in rawwords
		tmpholder.push(word) if word["name"] in names
	return tmpholder
	