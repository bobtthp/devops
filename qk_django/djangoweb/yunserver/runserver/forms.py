#coding: utf8
from django import forms
from .models import Pentesting, Downlog, Azurevm


class openForm(forms.ModelForm):

    class Meta:
        model = Pentesting
        fields = ['proname', 'prourl', 'proauth', 'proqq', 'prohost']


class downForm(forms.ModelForm):
    class Meta:
        model = Downlog
        fields = ['projectname', 'serverip', 'serverport', 'username', 'password', 'location']


class azureForm(forms.ModelForm):
    choices = []


    coll2 = ['qingkeazuretest', '云测试']
    coll1 = ['qingkeazuresim', '云仿真']
    collages = [coll2, coll1]
    for college in collages:
        choices += [(college)]
    college = forms.ChoiceField(choices, label=u'类型' )

    class Meta:
        model = Azurevm

        fields = ['college', 'name', 'ipaddr']
