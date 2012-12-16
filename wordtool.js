// Generated by CoffeeScript 1.4.0
(function() {
  var argv, checkforseparateddefinition, endfile, file, filewithext, mp, optimist, pos1, startfile, wordloader, wordprocessor, _i, _len, _ref;

  optimist = require('./optimist/index');

  wordloader = require('./wordloader').wordloader;

  wordprocessor = require("./wordprocessor/main").wordprocessor;

  checkforseparateddefinition = (function() {

    function checkforseparateddefinition() {}

    checkforseparateddefinition.prototype.call = function(arg) {
      if (arg["separated-definition"] && !arg["with-definition"]) {
        return false;
      } else {
        return true;
      }
    };

    checkforseparateddefinition.prototype.toString = function() {
      return 'You cannot enable "separated-definition" without enable "with-definition" first.';
    };

    return checkforseparateddefinition;

  })();

  argv = optimist.usage("A handy tool helps you to deal with new words.\nUsage:$0").boolean("with-index").describe("with-index", "Give each word an index number.").boolean("strip-comments").describe("strip-comments", "Strip away comments after #.").boolean("shuffle-words").describe("shuffle-words", "Output words into random order.").boolean("with-definition").describe("with-definition", "Search Powerdict and append definition after each word.").boolean("separated-definition").describe("separated-definition", "Put definitions into a individual file").boolean("help").alias("help", "h")["default"]("help", false).describe("help", "Print out this help.").alias("output", "o")["default"]("output", "/").describe("output", "Specify the output file.").alias("inputdir", "e")["default"]("inputdir", "./").describe("inputdir", "Specify where to search for input file.").boolean("debug").describe("debug", "Enable verbose output").option("with-index", {
    alias: "i",
    "default": true
  }).option("strip-comments", {
    alias: "c",
    "default": false
  }).option("shuffle-words", {
    alias: "s",
    "default": false
  }).option("with-definition", {
    alias: "d",
    "default": false
  }).option("separated-definition", {
    alias: "p",
    "default": false
  }).option("debug", {
    alias: "b",
    "default": false
  }).check(new checkforseparateddefinition).argv;

  if (argv._.length < 1) {
    if (argv.help) {
      console.log(optimist.help());
    } else {
      console.log("You need to specify the file(s) that contain words and is(are) needed to be processed.\n\n" + (optimist.help()));
    }
  }

  _ref = argv._;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    file = _ref[_i];
    filewithext = [];
    pos1 = file.indexOf("-");
    startfile = parseInt(file.slice(0, pos1));
    endfile = parseInt(file.slice(pos1 + 1));
    while (startfile <= endfile) {
      filewithext.push("" + startfile + ".txt");
      startfile++;
    }
    mp = new wordloader(argv.inputdir, filewithext);
    mp.on("end", function(data) {
      var eachword, i, words, wp, _j, _len1;
      words = [];
      for (i = _j = 0, _len1 = data.length; _j < _len1; i = ++_j) {
        eachword = data[i];
        words[i] = new Object();
        words[i]["name"] = eachword;
      }
      wp = new wordprocessor();
      wp.on("end", function() {
        if (argv.debug) {
          console.log("Word processor result:");
          return console.log(wp.getresult());
        }
      });
      return wp.process(words, argv);
    });
  }

}).call(this);
