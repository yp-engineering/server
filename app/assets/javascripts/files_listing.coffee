$ ->
  $("a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
    $('#files_listing').html(data)
