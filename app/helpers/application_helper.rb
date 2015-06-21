module ApplicationHelper
  #style flash messages, error messages and alerts
  def bootstrap_class_for(flash_type)
    if flash_type == "alert"
      "alert alert-dismissable alert-danger alert-icon"

    elsif flash_type == "notice"
      "alert alert-dismissable alert-success alert-icon"

    elsif flash_type == "warning"
      "alert alert-dismissable alert-warning alert-icon"      

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
      <div class="form-group" id: "#{id}" >
        <label class="col-sm-2 control-label">BIN/IIN:</label>
        <div class="col-sm-10">
          <input type='text', name="bin[]", placeholder="first 6 digits of your card number e.g 431940", class="form-control">
        </div>
      </div>
    HTML
    html = html.html_safe
    link_to(name, '#', class: 'add_fields', data: {id: id, fields: html.gsub("\n", "")})
  end
end