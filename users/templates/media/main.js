function delete_f(user_id, node){
    $.ajax({
        type: "POST",
        url:'http://127.0.0.1:8000/users/delete/',
        dataType: "json",
        data: { "user_id": user_id },
        success: function(data) {
            tr_node = node.parentNode;
            tr_node.parentNode.remove(tr_node);
        }
    });
}

function send_data(url, form_id){
    var inputs = $('#' + form_id +  ' :input');
    var values = {};
    inputs.each(function(){
        values[this.name] = $(this).val()
    });
    $.ajax({
        type: "POST",
        url: url,
        dataType: "json",
        data: values,
        success: function(){
            $('#message').show();
            if (form_id == 'create_form'){
                setTimeout(function(){
                window.location.href = 'http://127.0.0.1:8000/users/?';
            }, 3000);
            }
        }
    });
}

function prev_next_page(obj, num_of_pages, curr_page, num_of_elements){
    if (obj.id == 'next'){
        if (curr_page < num_of_pages){
            obj.href = 'http://127.0.0.1:8000/users/?page=' + (curr_page + 1) + '&num_of_elements=' + num_of_elements;
        }
    } else if (curr_page > 1){
            obj.href = 'http://127.0.0.1:8000/users/?page=' + (curr_page - 1) + '&num_of_elements=' + num_of_elements;
    }
}

function change_elements_number(obj, curr_page){
    var val = obj.options[obj.selectedIndex].value; 
    window.location.href = 'http://127.0.0.1:8000/users/?page=' + curr_page + '&num_of_elements=' + val;
    obj.options[obj.selectedIndex].selected = "selected"
}

$(document).ready(function() {
    var sel = $("#sel");
    if (sel.length){
        sel.val(elements_num);
    }
    $('#message').hide();
    $('#change_form').submit(function(event){
        event.preventDefault();
        send_data(this.action, this.id);
    });
    $('#create_form').submit(function(event){
        event.preventDefault();
        send_data(this.action, this.id);
    });
 
    // CSRF code
    function getCookie(name) {
        var cookieValue = null;
        var i = 0;
        if (document.cookie && document.cookie !== '') {
            var cookies = document.cookie.split(';');
            for (i; i < cookies.length; i++) {
                var cookie = jQuery.trim(cookies[i]);
                // Does this cookie string begin with the name we want?
                if (cookie.substring(0, name.length + 1) === (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
    var csrftoken = getCookie('csrftoken');

    function csrfSafeMethod(method) {
        // these HTTP methods do not require CSRF protection
        return (/^(GET|HEAD|OPTIONS|TRACE)$/.test(method));
    }
    $.ajaxSetup({
        crossDomain: false, // obviates need for sameOrigin test
        beforeSend: function(xhr, settings) {
            if (!csrfSafeMethod(settings.type)) {
                xhr.setRequestHeader("X-CSRFToken", csrftoken);
            }
        }
    }); 


});
