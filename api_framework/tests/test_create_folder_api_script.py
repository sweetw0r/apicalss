from api_utils import Calls
from unittest import TestCase
import httplib
from api_utils import Config


class TestClass(TestCase):

    @classmethod
    def setUpClass(cls):
        cls.calls = Calls()
        cls.config = Config()

    @classmethod
    def tearDownClass(cls):
        pass

    def SetUp(self):
        pass

    def tearDown(cls):
        pass

    def test_create_folder_positive(self):
        folder = self.calls.gen_random_name()
        resp = self.calls.create_folder(folder)
        assert resp.http_code == httplib.CREATED

    def test_creat_folder_incorrect_creadentials(self):
        folder = self.calls.gen_random_name()
        resp = self.calls.create_folder(folder, password='asasaa')
        assert resp.http_code == httplib.UNAUTHORIZED
        print(resp.json)
        assert resp.json['inputErrors']['credentials'][
            0]['code'] == 'INVALID_CREDENTIALS'
        assert resp.json['inputErrors']['credentials'][
            0]['msg'] == 'This request is unauthenticated.'\
            ' Please provide credentials and try again.'

    def test_perm(self):
        folder = self.calls.gen_random_name()
        resp = self.calls.create_folder(folder)
        assert resp.http_code == httplib.CREATED
        resp = self.calls.user_permision(
            folder, endpoint='/public-api/v1/perms/folder/')
        assert resp.http_code == httplib.OK
