import requests
import json


def create_folder(name, domain=None, username=None, password=None,
                  content_type=None, accept=None, method=None, test_path=None):
    if domain is None:
        domain = 'https://istepanko31.qa-egnyte.com'
    if username is None:
        username = 'admin'
    if password is None:
        password = 'apitest2'
    if content_type is None:
        content_type = 'application/json'
    if accept is None:
        accept = 'application/json'
    if method is None:
        method = "POST"
    if test_path is None:
        test_path = '/Shared/smoke_test/'

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
    return r

for i in range(5):
    resp = create_folder(name='test%s' % i)
    print('\n'
          'Folder %s created!\n'
          'Data:'
          '\n'
          '%s'
          '\n'
          'Status_code:'
          '\n'
          '%s' % (resp.content, resp.status_code, i))
