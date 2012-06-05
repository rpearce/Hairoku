$(document).ready ->
  $('#new-haiku').live('keyup', ->
    [_first, _second, _third] = $(this).val().split('\n');
    first_line_syllables      = syllableCount(_first)
    second_line_syllables     = syllableCount(_second)
    third_line_syllables      = syllableCount(_third)
    total_syllables           = first_line_syllables + second_line_syllables + third_line_syllables
    validate = (first_line_syllables and third_line_syllables isnt 5) or (second_line_syllables isnt 7) or (total_syllables isnt 17)

    if validate
      $('.haiku-validated').hide()
      $('.submit-button').hide()
      $('.immortality-achieved').hide()
      $('.asian-father').show()
    else
      $('.asian-father').hide()
      $('.haiku-validated').show()
      $('.submit-button').show()
    if $(this).val() is ''
      $('.asian-father').hide()
      $('.haiku-validated').hide()
      $('.submit-button').hide()
      $('.immortality-achieved').hide()
    $('.syllable-count').html('~' + total_syllables + ' syllables')
  )

  $('.submit-button').live('click', ->
    text  = $('#new-haiku').val()
    count = $('.syllable-count').text()
    submitHaiku({text: text}) if count is '~17 syllables'
  )

  $('.immortality-achieved').live('click', ->
    $('#new-haiku').val('')
    $('#new-haiku').trigger('keyup')
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

  submitHaiku = (hash) ->
    $.ajax
      type: 'post'
      url: "/post_haiku"
      data: JSON.stringify(hash)
      dataType: 'json'
      success: (message) ->
        $('.haiku-validated').animate({
          width: 'auto',
          height: 'auto'
        }, {
          complete: ->
            $('.submit-button').hide()
            $('.immortality-achieved').fadeIn()
          }
        )
      error: (a, b, c) ->
        console.log a
        console.log b
        console.log c

  # Take the haiku from and process it
  testHaiku = (haiku) ->
    # Split the haiku into three lines based on finding newline characters
    [_first, _second, _third] = haiku.split('\n')

    # Make sure the haiku is three lines
    if _first is undefined or _second is undefined or _third is undefined
      return false

    # Count 'em up
    first_line_syllables = testLine(_first)
    second_line_syllables = testLine(_second)
    third_line_syllables = testLine(_third)
    total_syllables = first_line_syllables + second_line_syllables + third_line_syllables

    # Validate that the lines match the syllable counts for a haiku
    # If fails_validation returns true, the entered text is not a haiku
    # If fails_validation returns false, the entered text is a haiku
    fails_validation = (
      first_line_syllables and
      third_line_syllables isnt 5
    ) or (
      second_line_syllables isnt 7
    ) or (
      total_syllables isnt 17
    )

    # Return whether the haiku is valid by flipping fails_validation
    return !fails_validation

  # Count the syllables in a line (returns the count of syllables)
  testLine = (line) ->
    words = line.split(' ')
    count = 0
    for word in words
      count = count + testWord(word)
    return count

  # Count the syllables in an individual word (returns the count of syllables)
  # Based on several assumptions:
  # - Ignore final -ES, -ED, -E (except for -LE)
  # - Words of three letters or less count as one syllable
  # - Consecutive vowels (up to two) count as one syllable
  # This method still has hiccups (for instance when dealining with compound
  # words like 'sometimes' it will return an extra syllable)
  testWord = (word) ->
    unless word is undefined
      # Downcase the word
      word = word.toLowerCase()

      # If the word is blank or the word is null return 0 syllables
      if word is '' or word is null then return 0
      # If the word is three letters or less return 1 syllable
      if word.length <= 3 and word.length > 0 then return 1

      # If the word has only one vowel, just return one syllable;
      # otherwise words like 'test' will break the regex and return
      # as zero syllables.
      unless word.match(/[aeiouy]/g).length <= 1
        # Remove vowel sounds that do not contribute to syllables
        word = word.replace(/[^laeiouy]es|ed|[^leaiouy]e$/, '')
        word = word.replace(/^y/, '')

      # Return the number of vowels remaining in the string
      return word.match(/[aeiouy]{1,2}/g).length
    else
      # If the word is undefined return 0 syllables
      return 0
