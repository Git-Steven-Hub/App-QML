from product import Product
from order import Order
from shift import Shift

burger = Product(1, "Burger simple", 1500.0, "food")
fries = Product(2, "Papas", 800.0, "food")

order = Order()
order.add_product(burger)
order.add_product(burger)
order.add_product(fries)

print("Items:", len(order.items))
print("Total:", order.total)
print("Status:", order.status)

order.pay()
print("Status after pay:", order.status)

shift = Shift()
shift.orders.append(order)

print("Total ventas:", shift.total_sales)