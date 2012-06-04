$(document).ready ->
  $('#new-haiku').live('keyup', ->
    [_first, _second, _third] = $(this).val().split('\n');
    first_line_syllables      = syllableCount(_first)
    second_line_syllables     = syllableCount(_second)
    third_line_syllables      = syllableCount(_third)
    total_syllables           = first_line_syllables + second_line_syllables + third_line_syllables

    if (first_line_syllables and third_line_syllables != 5) or (second_line_syllables != 7) or (total_syllables != 17)
      $('.haiku-validated').hide()
      $('.asian-father').show()
    else
      $('.asian-father').hide()
      $('.haiku-validated').show()

    $('.syllable-count').html('~' + total_syllables)
  )

  syllableCount = (word) ->
    unless word is undefined
      word = word.toLowerCase()
      if word is '' or word is null then return 0
      if word.length <= 3 and word.length > 0 then return 1
      word = word.replace(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '')
      word = word.replace(/^y/, '')
      return word.match(/[aeiouy]{1,2}/g).length
    else
      return 0