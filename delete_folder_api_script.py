import requests
import json


def create_folder(name, domain=None, username=None, password=None,
                  method=None, test_path=None):
    if domain is None:
        domain = 'https://istepanko31.qa-egnyte.com'
    if username is None:
        username = 'admin'
    if password is None:
        password = 'apitest2'
    if method is None:
        method = 'DELETE'
    if test_path is None:
        test_path = '/Shared/smoke_test/'

    endpoint = '/public-api/v1/fs'
    url = domain + endpoint + test_path + name
    data = dict()
    data = json.dumps(data)
    r = requests.request(
        url=url,
        auth=(username, password),
        method=method
        )
    return r

for i in range(5):
    resp = create_folder(name='test%s' % i)
    print('\n'
          'Folder %s removed!\n'
          'Data: '
          '%s'
          '\n'
          'Status_code: '
          '%s'
          '%s' % (resp.content, i, resp.status_code))