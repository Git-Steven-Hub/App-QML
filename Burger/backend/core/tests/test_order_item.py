from product import Product
from order_item import OrderItem

def test_subtotal():
    product = Product(1, "Burger", 1500.0, "food")
    item = OrderItem(product, 2)
    
    assert item.subtotal == 3000.0
    
def test_increase_decrease():
    product = Product(1, "Burger", 1500.0, "food")
    item = OrderItem(product)

    item.increase()
    assert item.quantity == 2

    item.decrease()
    assert item.quantity == 1

    item.decrease(5)
    assert item.quantity == 0