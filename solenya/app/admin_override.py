from django.contrib.admin import AdminSite


class AdminSiteOverride(AdminSite):
    site_header = 'LEVEL 3 / ROOM 304'


admin_site = AdminSiteOverride(name='admin_override')
admin_site.login_template = 'login.html'
