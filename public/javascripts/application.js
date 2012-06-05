(function() {

  $(document).ready(function() {
    var submitHaiku, syllableCount;
    $('#new-haiku').live('keyup', function() {
      var first_line_syllables, second_line_syllables, third_line_syllables, total_syllables, validate, _first, _ref, _second, _third;
      _ref = $(this).val().split('\n'), _first = _ref[0], _second = _ref[1], _third = _ref[2];
      first_line_syllables = syllableCount(_first);
      second_line_syllables = syllableCount(_second);
      third_line_syllables = syllableCount(_third);
      total_syllables = first_line_syllables + second_line_syllables + third_line_syllables;
      validate = (first_line_syllables && third_line_syllables !== 5) || (second_line_syllables !== 7) || (total_syllables !== 17);
      if (validate) {
        $('.haiku-validated').hide();
        $('.submit-button').hide();
        $('.immortality-achieved').hide();
        $('.asian-father').show();
      } else {
        $('.asian-father').hide();
        $('.haiku-validated').show();
        $('.submit-button').show();
      }
      if ($(this).val() === '') {
        $('.asian-father').hide();
        $('.haiku-validated').hide();
        $('.submit-button').hide();
        $('.immortality-achieved').hide();
      }
      return $('.syllable-count').html('~' + total_syllables + ' syllables');
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
    syllableCount = function(word) {
      if (word !== void 0) {
        word = word.toLowerCase();
        if (word === '' || word === null) return 0;
        if (word.length <= 3 && word.length > 0) return 1;
        word = word.replace(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '');
        word = word.replace(/^y/, '');
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
              $('.submit-button').hide();
              return $('.immortality-achieved').fadeIn();
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
