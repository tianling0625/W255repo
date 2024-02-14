from unittest import TestCase

from api.app import create_app


class UserTestCase(TestCase):
    def setUp(self):
        self.app = create_app("testing")
        self.app_context = self.app.app_context()
        self.app_context.push()
        self.client = self.app.test_client(use_cookies=True)

    def tearDown(self):
        self.app_context.pop()

    def test_root_response(self):
        response = self.client.get(
            "/",
            headers={"Content-Type": "application/json"},
        )

        self.assertEqual(response.status_code, 200)
