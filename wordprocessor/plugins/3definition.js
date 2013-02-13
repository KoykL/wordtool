// Generated by CoffeeScript 1.4.0
(function() {
  var events, flattern, http, processword, stripcomments, xml,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  events = require("events").EventEmitter;

  xml = require("xml2js");

  http = require('http');

  stripcomments = require("./1stripcomments");

  processword = (function(_super) {

    __extends(processword, _super);

    function processword() {}

    processword.prototype.process = function(iwords, argv) {
      var counter, each, options, parser, referencetable, that, tmpwords, word, words, words2, _i, _len;
      if (argv["argv"]["with-definition"]) {
        if (!argv["stripedcomments"]) {
          words = stripcomments.stripcomments(iwords);
        }
        referencetable = flattern(words);
        words2 = iwords;
        tmpwords = [];
        counter = 0;
        that = this;
        parser = new xml.Parser();
        parser.on("end", function(result) {
          var definition, each, key, object, sum, _i, _j, _len, _len1;
          sum = "";
          definition = result["dict"]["acceptation"];
          if (definition !== void 0) {
            for (_i = 0, _len = definition.length; _i < _len; _i++) {
              each = definition[_i];
              sum += each.replace(/^\s*|\s*$/g, "");
            }
          } else {
            sum += "Unknown";
          }
          key = result["dict"]["key"][0];
          object = referencetable[key];
          object["definition"] = sum;
          counter++;
          if (counter === words.length) {
            for (_j = 0, _len1 = words2.length; _j < _len1; _j++) {
              each = words2[_j];
              each["definition"] = referencetable[each["name"]]["definition"];
              tmpwords.push(each);
            }
            return that.emit("end", tmpwords);
          }
        });
        for (_i = 0, _len = words.length; _i < _len; _i++) {
          each = words[_i];
          word = each.name;
          options = {
            host: 'dict-co.iciba.com',
            port: 80,
            path: "/api/dictionary.php?w=" + word
          };
          http.get(options, function(res) {
            res.setEncoding("utf8");
            return res.on("data", function(data) {
              return parser.parseString(data);
            });
          });
        }
        return this.processed = true;
      } else {
        this.emit("end", void 0);
        return this.processed = false;
      }
    };

    processword.prototype.processed = function() {
      return this.processed;
    };

    return processword;

  })(events);

  flattern = function(words) {
    var each, tmpholder, _i, _len;
    tmpholder = {};
    for (_i = 0, _len = words.length; _i < _len; _i++) {
      each = words[_i];
      tmpholder[each["name"]] = each;
    }
    return tmpholder;
  };

  exports.processword = processword;

}).call(this);
