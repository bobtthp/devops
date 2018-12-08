from django import forms
from server.models import Service
from server.models import User

class serviceform(forms.ModelForm):
    class Meta:
        model = Service
        fields = ['ip','project_name','username','passwd']

