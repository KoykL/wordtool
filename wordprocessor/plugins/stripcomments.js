// Generated by CoffeeScript 1.4.0
(function() {
  var events, processword, stripcomments,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  events = require("events").EventEmitter;

  processword = (function(_super) {

    __extends(processword, _super);

    function processword() {}

    processword.prototype.process = function(words, argv) {
      var each, i, processedwords, _i, _len;
      if (argv["strip-comments"]) {
        processedwords = stripcomments(words);
        for (i = _i = 0, _len = words.length; _i < _len; i = ++_i) {
          each = words[i];
          each["name"] = processedwords[i];
        }
        this.processed = true;
      } else {
        this.processed = false;
      }
      return this.emit("end");
    };

    processword.prototype.processed = function() {
      return this.processed;
    };

    return processword;

  })(events);

  stripcomments = function(words) {
    var each, eachobject, pos, posspace, postab, tmpholder, worddone, wordhaventstrippedblanks, wordsstrippedspace, _i, _len;
    tmpholder = [];
    for (_i = 0, _len = words.length; _i < _len; _i++) {
      eachobject = words[_i];
      each = eachobject["name"];
      pos = each.indexOf("#");
      wordhaventstrippedblanks = pos >= 0 ? each.slice(0, pos) : each;
      posspace = wordhaventstrippedblanks.indexOf(" ");
      wordsstrippedspace = posspace >= 0 ? wordhaventstrippedblanks.slice(0, posspace) : wordhaventstrippedblanks;
      postab = wordsstrippedspace.indexOf("\t");
      worddone = postab >= 0 ? wordsstrippedspace.slice(0, postab) : wordsstrippedspace;
      if (worddone.length !== 0) {
        tmpholder.push(worddone);
      }
    }
    return tmpholder;
  };

  exports.processword = processword;

  exports.stripcomments = stripcomments;

}).call(this);
