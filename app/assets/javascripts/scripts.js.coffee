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
				console.log data
				$('#cartItems').text(data.cart_item_count)
				toastr.success('Item successfully added to cart', {timeOut: 1000})

	$('.removeFromCart').on 'click', (event) ->
		console.log $('#totalPrice').text()
		item_id = $(this).data('id')
		parent = $(this).parent()
		parents_parent = parent.parent()

		updateTotal = (origTotal, itemPrice) ->
			newTotal = origTotal - itemPrice
			$('#totalPrice').text(newTotal)

		$.ajax
			url: '/remove_from_cart'
			type: 'POST'
			data:
				id: item_id
			success: (data, status, response) ->
				parents_parent.remove()
				updateTotal($('#totalPrice').text(), data.item_price)
				$('#cartItems').text(data.cart_item_count) 
				toastr.success('Item successfully removed from cart', {timeOut: 1000})
