from user import User

def test_admin_role():
    admin = User("root", "admin")
    user = User("caja", "cashier")

    assert admin.is_admin is True
    assert user.is_admin is False