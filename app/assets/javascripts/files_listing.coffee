$ ->
  $("a[data-remote]")
    .on "ajax:success", (e, data, status, xhr) ->
      $('#files_listing').html(data)
    .on "ajax:error", (xhr, status, err) ->
      console.log("ajax error", status, err)
