
$('#invitation_project_role_input input[type="radio"]')
  # ask to select existing vendor or create new one
  .change( (evt)-> 
    if $('#invitation_project_role_input input[type="radio"]:checked').closest('label:contains("Vendor")').length == 1
    # if $(this).closest('label:contains("Vendor")').length == 1
      $('#vendor-options').show('fast')
    else
      $('#vendor-options').hide('fast')
  # trigger above in case option was preselected
  ).change() 

$('#is_new_vendor_input input[type="radio"]')
  .change( (evt) ->
    # enable what's appropriate
    if $('#is_new_vendor_input input[type="radio"]:checked').closest('label:contains("Existing Vendor")').length == 1
      $('#is_new_vendor_input #invitation_vendor').prop('disabled', false)
      $('#is_new_vendor_input #invitation_new_vendor_name').prop('disabled', true)
      $('#is_new_vendor_input #invitation_new_vendor_type').prop('disabled', true)
    else
      $('#is_new_vendor_input #invitation_vendor').prop('disabled', true)
      $('#is_new_vendor_input #invitation_new_vendor_name').prop('disabled', false)
      $('#is_new_vendor_input #invitation_new_vendor_type').prop('disabled', false)
  # trigger
  )