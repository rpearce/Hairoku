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
