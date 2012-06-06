(function() {

  $(document).ready(function() {
    var submitHaiku, testHaiku, testLine, testWord;
    $('#new-haiku').live('keyup', function() {
      var valid;
      valid = testHaiku($(this).val());
      if (!valid) {
        $('.haiku-validated').hide();
        $('.submit-button').hide();
        $('.immortality-achieved').hide();
        $('.asian-father').show();
      } else {
        $('.asian-father').fadeOut({
          complete: function() {
            $('.haiku-validated').fadeIn();
            return $('.submit-button').show();
          }
        });
      }
      if ($(this).val() === '') {
        $('.asian-father').hide();
        $('.haiku-validated').hide();
        $('.submit-button').hide();
        return $('.immortality-achieved').hide();
      }
    });
    $('.submit-button').live('click', function() {
      var count, text;
      text = $('#new-haiku').val();
      count = $('.syllable-count').text();
      if (count === '~17 syllables') {
        return submitHaiku({
          text: text
        });
      }
    });
    $('.immortality-achieved').live('click', function() {
      $('#new-haiku').val('');
      return $('#new-haiku').trigger('keyup');
    });
    testHaiku = function(haiku) {
      var fails_validation, first_line_syllables, second_line_syllables, third_line_syllables, total_syllables, _first, _ref, _second, _third;
      _ref = haiku.split('\n'), _first = _ref[0], _second = _ref[1], _third = _ref[2];
      first_line_syllables = testLine(_first);
      second_line_syllables = testLine(_second);
      third_line_syllables = testLine(_third);
      total_syllables = first_line_syllables + second_line_syllables + third_line_syllables;
      $('.syllable-count').html('~' + total_syllables + ' syllables');
      if (first_line_syllables === 5) {
        $('.line-one').show();
      } else {
        $('.line-one').hide();
      }
      if (second_line_syllables === 7) {
        $('.line-two').show();
      } else {
        $('.line-two').hide();
      }
      if (third_line_syllables === 5) {
        $('.line-three').show();
      } else {
        $('.line-three').hide();
      }
      fails_validation = (first_line_syllables && third_line_syllables !== 5) || (second_line_syllables !== 7) || (total_syllables !== 17);
      return !fails_validation;
    };
    testLine = function(line) {
      var count, word, words, _i, _len;
      if (line === void 0) return 0;
      words = line.split(' ');
      count = 0;
      for (_i = 0, _len = words.length; _i < _len; _i++) {
        word = words[_i];
        count = count + testWord(word);
      }
      return count;
    };
    testWord = function(word) {
      if (word !== void 0) {
        word = word.toLowerCase();
        if (word === '' || word === null) return 0;
        if (word.length <= 3 && word.length > 0) return 1;
        if (!(word.match(/[aeiouy]/g).length <= 1)) {
          word = word.replace(/[^laeiouy]es|ed|[^leaiouy]e$/, '');
          word = word.replace(/^y/, '');
        }
        return word.match(/[aeiouy]{1,2}/g).length;
      } else {
        return 0;
      }
    };
    return submitHaiku = function(hash) {
      return $.ajax({
        type: 'post',
        url: "/post_haiku",
        data: JSON.stringify(hash),
        dataType: 'json',
        success: function(message) {
          return $('.haiku-validated').animate({
            width: 'auto',
            height: 'auto'
          }, {
            complete: function() {
              return $('.submit-button').fadeOut({
                complete: function() {
                  return $('.immortality-achieved').fadeIn();
                }
              });
            }
          });
        },
        error: function(a, b, c) {
          console.log(a);
          console.log(b);
          return console.log(c);
        }
      });
    };
  });

}).call(this);
