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

	# checkbox toggle
	cb_toggle = (checkboxes) ->
		$('.selectAll').on 'click', (event) ->
			if $(this).prop('checked') is true
				$.each checkboxes, (checkbox) ->
					checkboxes[checkbox].checked = true
			else
				$('input:checkbox').removeAttr('checked')

	cb_toggle(document.getElementsByName('item_ids[]'))
	cb_toggle(document.getElementsByName('cc_ids[]'))

	# add multiple items to cart
	$('#addMultipleToCart').on 'click', (event) ->
		item_ids = Array()

		$('[name="cc_ids[]"]:checked').each () ->
			item_ids.push($(this).val())

		if item_ids.length is 0
			sweetAlert("Warning!", "You have not selected any items to buy", "warning");
		else
			$.ajax
				url: "/add_to_cart"
				type: 'POST'
				data:
					ids: item_ids
				success: (data, status, response) ->
					console.log data
					$('#cartItems').text(data.cart_item_count)
					toastr.success('Items successfully added to cart', {timeOut: 1000})

	# delete multiple cards
	$('#deleteAll').on 'click', (event) ->
		item_ids = Array()

		$('[name="item_ids[]"]:checked').each () ->
			item_ids.push($(this).val())

		if item_ids.length is 0
			sweetAlert("Oops!", "Please select Items to delete", "error")
		else
			$.ajax
				url: "/delete_multiple_items"
				type: 'POST'
				data:
					ids: item_ids
				success: (data, status, response) ->
					console.log data
					$.each data.ids, (key, value) ->
						$("row_#{value}").hide()
					toastr.success('Items successfully deleted', {timeOut: 1000})
