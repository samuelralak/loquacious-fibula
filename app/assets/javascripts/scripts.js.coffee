jQuery -> 
	$('form').on 'click', '.add_fields', (event) -> 
		time = new Date().getTime()
		regexp = new RegExp($(this).data('id'), 'g')
		$(this).before($(this).data('fields').replace(regexp, time))
		event.preventDefault()
		
	$('form').on 'click', '.remove_fields', (event) -> 
		parent = $(this).parent()
		parents_parent = parent.parent()
		parents_parent.remove()
		event.preventDefault()

	$('.addToCart').on 'click', (event) -> 
		console.log $(this).data('item')
		$.ajax
			url: '/add_to_cart'
			type: 'POST'
			data:
				id: $(this).data('item')
			success: (data, status, response) ->
				toastr.success('Item successfully added to cart', {timeOut: 1000})
			error: ->
				toastr.success('An error occured while adding item')
			dataType: "json"
