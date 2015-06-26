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
		item_id = $(this).data('item')
		$.ajax
			url: '/add_to_cart'
			type: 'POST'
			data:
				id: item_id
			success: (data, status, response) ->
				console.log data.cart_item_count
				$('#cartItems').text(data.cart_item_count) 
				toastr.success('Item successfully added to cart', {timeOut: 1000})