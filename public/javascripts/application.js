(function() {

  $(document).ready(function() {
    var syllableCount;
    $('#new-haiku').live('keyup', function() {
      var first_line_syllables, second_line_syllables, third_line_syllables, total_syllables, _first, _ref, _second, _third;
      _ref = $(this).val().split('\n'), _first = _ref[0], _second = _ref[1], _third = _ref[2];
      first_line_syllables = syllableCount(_first);
      second_line_syllables = syllableCount(_second);
      third_line_syllables = syllableCount(_third);
      total_syllables = first_line_syllables + second_line_syllables + third_line_syllables;
      if ((first_line_syllables && third_line_syllables !== 5) || (second_line_syllables !== 7) || (total_syllables !== 17)) {
        $('.asian-father').show();
      } else {
        $('.asian-father').hide();
      }
      return $('.syllable-count').html('~' + total_syllables);
    });
    return syllableCount = function(word) {
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
  });

}).call(this);
