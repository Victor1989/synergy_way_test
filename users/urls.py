from django.conf.urls import url
from views import CursesView, UsersView, delete_user, create_user, change_user

urlpatterns = [
    url(r'^$', UsersView, name='users'),
    url(r'^courses/$', CursesView, name='courses'),
    url(r'^delete/', delete_user, name='delete'),
    url(r'^create/$', create_user, name='create'),
    url(r'^change/', change_user, name='change')
]
