module ApplicationHelper
    def satoshi_to_bitcoin(satoshi)
        bitcoin = 0.00
        satoshi = satoshi.to_f
        bitcoin = satoshi/100000000*1
        bitcoin
    end
  #style flash messages, error messages and alerts
  def bootstrap_class_for(flash_type)
    if flash_type == "alert"
      "alert alert-dismissable alert-danger"

    elsif flash_type == "notice"
      "alert alert-dismissable alert-success"

    elsif flash_type == "warning"
      "alert alert-dismissable alert-warning"

    else
      flash_type.to_s

    end
  end

  def form_error_messages(resource)
    return '' if resource.errors.empty?

    messages =resource.errors.full_messages.map { |message|
      content_tag(:li, message)
    }.join

    html = <<-HTML
    <div class="alert alert-danger alert-block alert-icon">
      <button type="button" class="close" data-dismiss="alert">x</button>
          #{messages}
    </div>
    HTML

    html.html_safe
  end

  def link_to_add_field(name)
    id = SecureRandom.base64(10)
    html = <<-HTML
      <div class="form-group" id: "group#{id}" >
        <label class="col-sm-2 control-label">Card:</label>
        <div class="col-sm-8">
         <input type='text', name="bin[]", placeholder="card_number|expiry|cvv", class="form-control">
        </div>
        <div class="col-sm-2" style="padding-top: 10px !important;">
          <a href='#' class='remove_fields' id="#{id}" style="color: #e74c3c !important;"><i class="fa fa-close"></i> remove </a>
        </div>
      </div>
    HTML
    html = html.html_safe
    link_to(name, '#', class: 'add_fields', style: 'margin-left: 17px', data: {id: id, fields: html.gsub("\n", "")})
  end
end
