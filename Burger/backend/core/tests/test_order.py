import pytest
from product import Product
from order import Order

def test_add_product():
    burger = Product(1, "Burger", 1500.0, "food")
    order = Order()

    order.add_product(burger)
    order.add_product(burger)

    assert len(order.items) == 1
    assert order.items[0].quantity == 2

def test_total():
    burger = Product(1, "Burger", 1500.0, "food")
    fries = Product(2, "Papas", 800.0, "food")

    order = Order()
    order.add_product(burger)
    order.add_product(fries)

    assert order.total == 2300.0

def test_pay_empty_order():
    order = Order()

    with pytest.raises(ValueError):
        order.pay()