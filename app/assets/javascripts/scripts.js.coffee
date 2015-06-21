jQuery -> 
	$('form').on 'click', '.add_fields', (event) -> 
		time = new Date().getTime()
		regexp = new RegExp($(this).data('id'), 'g')
		$(this).before($(this).data('fields').replace(regexp, time))
		event.preventDefault()
		
	$('form').on 'click', '.remove_fields', (event) -> 
		parent = $(this).parent()
		parents_parent = parent.parent()
		parents_parent.hide()
		event.preventDefault()