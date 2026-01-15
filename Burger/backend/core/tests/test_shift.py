from shift import Shift
from order import Order
from product import Product

def test_total_sales():
    burger = Product(1, "Burger", 1500.0, "food")

    order1 = Order()
    order1.add_product(burger)
    order1.pay()

    order2 = Order()
    order2.add_product(burger)

    shift = Shift()
    shift.orders.extend([order1, order2])

    assert shift.total_sales == 1500.0