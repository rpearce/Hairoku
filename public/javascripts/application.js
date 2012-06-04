(function() {

  $(document).ready(function() {
    var syllableCount;
    $('#new-haiku').live('keyup', function() {
      var syllables;
      syllables = syllableCount($(this).val());
      return $('.syllable-count').html(syllables);
    });
    return syllableCount = function(word) {
      word = word.toLowerCase();
      if (word === '' || word === null) return 0;
      if (word.length <= 3 && word.length > 0) return 1;
      word = word.replace(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '');
      word = word.replace(/^y/, '');
      return word.match(/[aeiouy]{1,2}/g).length;
    };
  });

}).call(this);
