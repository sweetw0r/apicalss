import requests
import json
from ConfigParser import SafeConfigParser
import os
import time


# class Config:
#     def __init__(self):
#         self.parser = SafeConfigParser()
#         if os.path.isfile('config.ini'):
#             self.parser.raad('cofig.ini')
#         else:
#             print('No config.ini found under root folder.')
#         self.domain = self.parser.get('Server','domain')
#         self.admin_login = self.parser.get('Server', 'user')
#         self.password = self.parser.get('Server', 'passwd')
#         self.puser = self.parser.get('Server', 'puser')
#         self.testdata = ''./test_files'

class Config:
    def __init__(self):
        self.parser = SafeConfigParser()
        if os.path.isfile('config.ini'):
            self.parser.read('config.ini')
        else:
            print('No config.ini found under root folder.')
        self.domain = self.parser.get('Server', 'domain')
        self.admin_login = self.parser.get('Server', 'admin')
        self.password = self.parser.get('Server', 'password')
        self.test_path = self.parser.get('Server', 'test_path')
        self.puser = self.parser.get('Server', 'puser')
        self.permission = self.parser.get('Server', 'permission')

# f = Config()
# print(f.admin_login)
# print(f.password)


class Response:
    def __init__(self):
        self.http_code = 0
        self.jsom = dict()
        self.headers = dict()


class Calls:
    def __init__(self):
        self.config = Config()
        self.no_json = 'noJson'

    def create_folder(self, name, domain=None,
                      username=None, password=None,
                      content_type=None,
                      accept=None, method=None, test_path=None):
        if domain is None:
            domain = self.config.domain
        if username is None:
            username = self.config.admin_login
        if password is None:
            password = self.config.password
        if content_type is None:
            content_type = 'application/json'
        if accept is None:
            accept = 'application/json'
        if method is None:
            method = 'POST'
        if test_path is None:
            test_path = self.config.test_path

        endpoint = '/public-api/v1/fs/'
        url = domain + endpoint + test_path + name
        headers = dict()
        headers['Content-Type'] = content_type
        headers['Accept'] = accept
        data = dict()
        data['action'] = 'add_folder'
        data = json.dumps(data)
        r = requests.request(
            url=url,
            auth=(username, password),
            headers=headers,
            data=data,
            method=method
        )
        try:
            json_resp = json.loads(r.content)
        except ValueError:
            if method == 'OPTIONS':
                json_resp = r.content
            else:
                json_resp = self.no_json

        r.json = json_resp
        response = Response()
        response.http_code = r.status_code
        response.json = r.json
        response.headers = r.headers
        return response

    @staticmethod
    def gen_random_name():
        return 'dynamic_name_%s' % str(time.time()).replace('.', '')

    def delete_folder(self, name, domain=None,
                      username=None, password=None,
                      content_type=None,
                      accept=None, method=None, test_path=None):
        if domain is None:
            domain = self.config.domain
        if username is None:
            username = self.config.admin_login
        if password is None:
            password = self.config.password
        if content_type is None:
            content_type = 'application/json'
        if accept is None:
            accept = 'application/json'
        if method is None:
            method = 'DELETE'
        if test_path is None:
            test_path = self.config.test_path

        endpoint = '/public-api/v1/fs/'
        url = domain + endpoint + test_path + name
        headers = dict()
        headers['Content-Type'] = content_type
        headers['Accept'] = accept
        r = requests.request(
            url=url,
            auth=(username, password),
            headers=headers,
            method=method
        )

        try:
            json_resp = json.loads(r.content)
        except ValueError:
            if method == 'OPTIONS':
                json_resp = r.content
            else:
                json_resp = self.no_json

        r.json = json_resp
        response = Response()
        response.http_code = r.status_code
        response.json = r.json
        response.headers = r.headers
        return response


    def test_user_permision(self, name, permission=None, puser=None, domain=None,
                      username=None, password=None,
                      content_type=None,
                      accept=None, method=None, test_path=None):
        if domain is None:
            domain = self.config.domain
        if username is None:
            username = self.config.admin_login
        if password is None:
            password = self.config.password
        if content_type is None:
            content_type = 'application/json'
        if accept is None:
            accept = 'application/json'
        if method is None:
            method = 'POST'
        if test_path is None:
            test_path = self.config.test_path
        if puser is None:
            puser = self.config.puser
        if permission is None:
            permission = self.config.permission

        endpoint = '/public-api/v1/fs/'
        url = domain + endpoint + test_path + name
        headers = dict()
        headers['Content-Type'] = content_type
        headers['Accept'] = accept
        permission = dict()
        permission['users'] = [puser]
        permission['permission'] = permission
        permission = json.dumps(permission)
        r = requests.request(
            url=url,
            auth=(username, password),
            headers=headers,
            permission=permission,
            method=method
        )
        try:
            json_resp = json.loads(r.content)
        except ValueError:
            if method == 'OPTIONS':
                json_resp = r.content
            else:
                json_resp = self.no_json

        r.json = json_resp
        response = Response()
        response.http_code = r.status_code
        response.json = r.json
        response.headers = r.headers
        return response


        @staticmethod
        def gen_random_name():
            return 'dynamic_name_%s' % str(time.time()).replace('.', '')
