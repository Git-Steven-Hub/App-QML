import sqlite3
import json
from datetime import datetime
from pathlib import Path

class DataBase:
    _instance = None
    _initialized = False
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance.connection = None
            cls._instance.cursor = None
            cls._instance.db_path = None
            
        return cls._instance
    
    def __init__(self):
        if DataBase._initialized:
            return
            
        base_dir = Path(__file__).resolve().parent
        self.db_path = base_dir / "burger.db"
        self.connect()
        DataBase._initialized = True
        
    def connect(self):
        if self.connection is None:
            self.connection = sqlite3.connect(self.db_path)
            self.cursor = self.connection.cursor()
            self.create_tables()
            self.init_products_json()
        
    def load_json_data(self):
        json_path = Path(__file__).resolve().parent.parent / "data" / "products.json"
        with open(json_path, "r", encoding="utf-8") as f:
            return json.load(f)
            
    def init_products_json(self):
        self.cursor.execute('''
                SELECT COUNT (*) FROM categories
            ''')
        
        if self.cursor.fetchone()[0] > 0:
            return

        data = self.load_json_data()
        
        for category in data["categories"]:
            self.cursor.execute('''
                    INSERT INTO categories (id, name, icon) VALUES (?, ?, ?)''',
                    (category["id"], category["name"], category["icon"])
                )
            
        for product in data["products"]:
            self.cursor.execute('''
                    INSERT INTO products (id, category_id, category_name, name, price, image) VALUES (?, ?, ?, ?, ?, ?)''',
                    (product["id"], product["category_id"], product["category_name"], product["name"], product["price"], product["image"])
                )
        self.connection.commit()
        
    def create_tables(self):
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS categories (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                icon TEXT
                )
            ''')
                
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS products (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                category_id INTEGER,
                category_name TEXT NOT NULL,
                name TEXT NOT NULL,
                price REAL NOT NULL,
                image TEXT,
                active INTEGER DEFAULT 1,
                FOREIGN KEY (category_id) REFERENCES categories(id)
                )
            ''')
        
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS promotions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                price REAL NOT NULL,
                active INTEGER DEFAULT 1
                )
            ''')
        
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS promotions_items (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                promotion_id INTEGER,
                product_id INTEGER,
                quantity INTEGER,
                FOREIGN KEY (promotion_id) REFERENCES promotions(id),
                FOREIGN KEY (product_id) REFERENCES products(id)
                )
            ''')
        
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS orders (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                datetime TEXT,
                client_name TEXT,
                client_phone INTEGER,
                payment_method TEXT,
                total REAL,
                status TEXT
                )
            ''')
        
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS orders_items (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                order_id INTEGER,
                item_id INTEGER,
                item_type TEXT,
                category_id INTEGER,
                category_name TEXT NOT NULL,
                name TEXT,
                notes TEXT,
                unit_price REAL,
                quantity INTEGER,
                FOREIGN KEY (order_id) REFERENCES orders(id)
                )
            ''')
        
        self.connection.commit()
    
    def get_categories(self):
        self.cursor.execute('''
                SELECT * FROM categories
            ''')
        
        return self.cursor.fetchall()
    
    def get_products(self):
        self.cursor.execute('''
                SELECT p.id, p.category_id, c.name as category_name, p.name, p.price, p.image FROM products p JOIN categories c ON p.category_id = c.id               
            ''')
        
        return self.cursor.fetchall()
    
    def insert_order(self, items, client_name, client_phone, payment_method, total, status="En curso"):
        now = datetime.now().strftime("%d/%m/%Y, %H:%M:%S")
        
        self.cursor.execute('''
                INSERT INTO orders (datetime, client_name, client_phone, payment_method, total, status) VALUES (?, ?, ?, ?, ? ,?)''',
                (now, client_name, client_phone, payment_method, total, status))
        
        order_id = self.cursor.lastrowid
        
        for item in items:
            self.cursor.execute('''
                INSERT INTO orders_items (order_id, item_id, item_type, category_id, category_name, name, notes, unit_price, quantity) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)''',
                (order_id, item["item_id"],
                 item["item_type"],
                 item["category_id"],
                 item["category_name"],
                 item["name"],
                 item["notes"],
                 item["unit_price"],
                 item["quantity"])
                )
        
        self.connection.commit()
        
    def get_orders(self):
        self.cursor.execute('''
                SELECT id, datetime, total, status FROM orders ORDER BY id DESC
            ''')
        
        return self.cursor.fetchall()
    
    def get_orders_items(self, order_id):
        self.cursor.execute('''
                SELECT id, item_id, item_type, category_id, category_name, name, unit_price, quantity FROM orders_items WHERE order_id = ?''',
                (order_id,))
        
        return self.cursor.fetchall()
    
    def update_status(self, order_id, status):
        self.cursor.execute('''
            UPDATE orders
            SET status = ?
            WHERE id= ? 
            ''', (status, order_id))
        
        self.connection.commit()
        
    def close_system(self):
        if hasattr(self, "connection"):
            self.connection.commit()
            self.connection.close()