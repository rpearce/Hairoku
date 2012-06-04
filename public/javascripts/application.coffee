$(document).ready ->
  $('#new-haiku').live('keyup', ->
    syllables = syllableCount($(this).val())
    $('.syllable-count').html(syllables)
  )

  syllableCount = (word) ->
    word = word.toLowerCase()
    if word is '' or word is null then return 0
    if word.length <= 3 and word.length > 0 then return 1
    word = word.replace(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '')
    word = word.replace(/^y/, '')
    return word.match(/[aeiouy]{1,2}/g).length
