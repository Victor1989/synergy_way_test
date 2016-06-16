import json

from django.shortcuts import render
from django.db import connection
from django.http import Http404, HttpResponse

# Create your views here.

def run_procedure(proc_name, *args):
    cursor = connection.cursor()
    cursor.execute("call {0}({1});".format(proc_name, 
                                           ','.join([str(i) for i in args])))
    result = cursor.fetchall()
    cursor.close()

    return result

def CursesView(request):
    context = {
        "Courses": run_procedure("get_curses_list")
    }

    return render(request, 'users/courses.html', context)

def UsersView(request): 
    if ('page' not in request.GET) or ( not request.GET['page']):
        page = 1
    else:
        page = int(request.GET['page']) 
    if ('num_of_elements' not in request.GET)  \
       or (not request.GET['num_of_elements']):
        num_of_elements = 1
    else:
        num_of_elements = int(request.GET['num_of_elements'])
    offset = 0 if page == 1 else num_of_elements * (page-1)
    if ('name' in request.GET) and (request.GET['name']):
        users_num = run_procedure('get_users_number_name','"' 
                                  +  request.GET['name'] + '"')[0][0]
        users = run_procedure('get_users_by_name', num_of_elements, 
                              offset, '"' + request.GET['name'] + '"')
    else:
        users_num = run_procedure('get_users_number')[0][0]
        users = run_procedure('get_users_list', num_of_elements, offset)
    num_of_pages =   users_num / num_of_elements
    if users_num % num_of_elements > 0:
        num_of_pages += 1
    if page > num_of_pages:
        page = 1 
    context = {
        "Users": users,
        "pages": range(1, num_of_pages + 1),
        "num_of_pages": num_of_pages,
        "curr_page":  page,
        "num_of_elements": num_of_elements
    }

    return render(request, 'users/users.html', context)

def delete_user(request):
    if request.POST and request.is_ajax():
        run_procedure('delete_user', int(request.POST['user_id']))
        context = {
            "success": True
        }
        
        return HttpResponse(json.dumps(context), content_type='application/json')
    else:
        raise Http404

def create_user(request):
    if not request.POST:
        
       return render(request, 'users/create_user.html')
    elif request.is_ajax():
       name = '"' + request.POST['name'] + '"'
       email = '"' + request.POST['email'] + '"'
       phone = '"' + request.POST['phone'] + '"'
       mobilephone = '"' + request.POST['mobilephone'] + '"'
       status = '"' + request.POST['status'] + '"'
       run_procedure('create_user', name, email, phone, mobilephone, status)
       context = {
           "success": True
       }
       
       return HttpResponse(json.dumps(context), content_type='application/json')

def change_user(request): 
    if not request.POST: 
       user_id = int(request.GET['user_id'])
       user = run_procedure('get_user', user_id)
       context = {
           'user_id': user_id,
           'name': user[0][1],
           'email': user[0][2],
           'phone': user[0][3],
           'mobilephone': user[0][4],
           'status': user[0][5],
           'status_options': ['Active', 'Inactive']
       }

       return render(request, 'users/change_user.html', context)
    elif request.is_ajax():
        user_id = int(request.POST['user_id'])
        email = '"' + request.POST['email'] + '"'
        phone = '"' + request.POST['phone'] + '"'
        mobilephone = '"' + request.POST['mobilephone'] + '"'
        status = '"' + request.POST['status'] + '"'
        run_procedure('update_user', user_id, email, phone, mobilephone, status)
        context = {
            "success": True
        }

        return HttpResponse(json.dumps(context), content_type='application/json')

