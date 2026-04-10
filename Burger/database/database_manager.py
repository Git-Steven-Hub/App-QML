import sqlite3
import json
import logging
from datetime import datetime
from pathlib import Path

class DataBase:
    _instance = None
    _initialized = False
    logger = logging.getLogger("DataBase")
    
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
            self.init_promos_json()
        
    def load_products_json(self):
        try:
            json_path = Path(__file__).resolve().parent.parent / "data" / "products.json"
            with open(json_path, "r", encoding="utf-8") as f:
                return json.load(f)
            
        except Exception as e:
            self.logger.error(f"Error al cargar datos JSON(load_json_data): {e}")
            return []
        
    def load_promos_json(self):
        try:
            json_path = Path(__file__).resolve().parent.parent / "data" / "promos.json"
            with open(json_path, "r", encoding="utf-8") as f:
                return json.load(f)
            
        except Exception as e:
            self.logger.error(f"Error al cargar datos JSON(load_promos_json): {e}")
            return []
    
            
    def init_products_json(self):
        try:
            self.cursor.execute('''
                    SELECT COUNT (*) FROM categories
                ''')
            
            if self.cursor.fetchone()[0] > 0:
                return

            data = self.load_products_json()
            
            for category in data["categories"]:
                self.cursor.execute('''
                        INSERT INTO categories (id, name, icon) VALUES (?, ?, ?)''',
                        (category["id"], category["name"], category["icon"])
                    )
                
                if "notes" in category:
                    for note in category["notes"]:
                        self.cursor.execute('''
                                    INSERT INTO categories_notes (category_id, notes) VALUES (?, ?)''',
                                    (category["id"], note))
                
            for product in data["products"]:
                self.cursor.execute('''
                        INSERT INTO products (id, category_id, category_name, name, price, image) VALUES (?, ?, ?, ?, ?, ?)''',
                        (product["id"], product["category_id"], product["category_name"], product["name"], product["price"], product["image"])
                    )
            
            self.connection.commit()
        
        except Exception as e:
            self.logger.error(f"Error al inicializar productos desde JSON(init_products_json): {e}")
            return []
        
    def init_promos_json(self):
        try:
            self.cursor.execute('''
                    SELECT COUNT (*) FROM promotions
                ''')
            
            if self.cursor.fetchone()[0] > 0:
                return
            
            data = self.load_promos_json()
            
            for promo in data["promotions"]:
                self.cursor.execute('''
                        INSERT INTO promotions (id, category_id, name, description, price, icon) VALUES (?, ?, ?, ?, ?, ?)''',
                        (promo["id"], promo["category_id"], promo["name"], promo["description"], promo["price"], promo["icon"])
                    )
                
            self.connection.commit()
                
        except Exception as e:
            self.logger.error(f"Error al inicializar promociones desde JSON(init_promos_json): {e}")
            return []
        
    def create_tables(self):
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT UNIQUE NOT NULL,
                password_hash TEXT NOT NULL,
                role TEXT DEFAULT 'vendedor'
                )
            ''')
        
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS categories (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                icon TEXT
                )
            ''')
        
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS categories_notes (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                category_id INTEGER,
                notes TEXT,
                FOREIGN KEY (category_id) REFERENCES categories(id)
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
                category_id INTEGER,
                name TEXT NOT NULL,
                description TEXT NOT NULL,
                price REAL NOT NULL,
                icon TEXT,
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
                is_delivery BOOLEAN,
                delivery_fee REAL,
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
        try:
            self.cursor.execute('''
                SELECT id, name, icon FROM categories ORDER BY id
            ''')
            return self.cursor.fetchall()
        
        except sqlite3.Error as e:
            self.logger.error(f"Error al obtener categorías(get_categories): {e}")
            return []
    
    def get_products(self):
        try:
            self.cursor.execute('''
                SELECT p.id, p.category_id, c.name as category_name, p.name, p.price, p.image FROM products p JOIN categories c ON p.category_id = c.id               
            ''')
            return self.cursor.fetchall()
        
        except sqlite3.Error as e:
            self.logger.error(f"Error al obtener productos(get_products): {e}")
            return []
        
    def get_promos(self):
        try: 
            self.cursor.execute('''
                SELECT p.id, p.category_id, c.name as category_name, p.name, p.description, p.price, p.icon FROM promotions p JOIN categories c ON p.category_id = c.id WHERE p.active = 1 ORDER BY p.id                
            ''')
            return self.cursor.fetchall()
        
        except Exception as e:
            self.logger.error(f"Error al obtener promociones(get_promos): {e}")
            return []
        
    def get_category_notes(self, category_id):
        try:
            data = self.load_products_json()
            
            if not data or "categories" not in data:
                return []
            
            for category in data["categories"]:
                if category["id"] == category_id:
                    return category.get("notes", [])
                
            return []
        
        except Exception as e:
            self.logger.error(f"Error en al obtener notas de categoría(get_category_notes): {e}")
            return []
    
    def insert_order(self, items, client_name, client_phone, payment_method, is_delivery, delivery_fee, total, status="En curso"):
        try:
            now = datetime.now().strftime("%d/%m/%Y, %H:%M:%S")
        
            self.cursor.execute('''
                    INSERT INTO orders (datetime, client_name, client_phone, payment_method, is_delivery, delivery_fee, total, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)''',
                    (now, client_name, client_phone, payment_method, is_delivery, delivery_fee, total, status))
            
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
        
        except Exception as e:
            self.logger.error(f"Error al insertar orden(insert_order): {e}")
            self.connection.rollback()
            return None
        
    def get_orders(self):
        try:
            self.cursor.execute('''
                    SELECT id, datetime, client_name, client_phone, payment_method, is_delivery, delivery_fee, total, status FROM orders ORDER BY id DESC
                ''')
            
            return self.cursor.fetchall()
        
        except Exception as e:
            self.logger.error(f"Error al obtener órdenes(get_orders): {e}")
            return []
    
    def get_orders_items(self, order_id):
        try:
            self.cursor.execute('''
                    SELECT id, item_id, item_type, category_id, category_name, name, notes, unit_price, quantity FROM orders_items WHERE order_id = ?''',
                    (order_id,))
            
            return self.cursor.fetchall()
        
        except Exception as e:
            self.logger.error(f"Error al obtener items de orden(get_orders_items): {e}")
            return []
    
    def update_status(self, order_id, status):
        try:
            self.cursor.execute('''
                UPDATE orders
                SET status = ?
                WHERE id= ? 
                ''', (status, order_id))
            
            self.connection.commit()
            return True
        
        except Exception as e:
            self.logger.error(f"Error al actualizar el estado(update_status): {e}")
            return False
        
    def close_system(self):
        if hasattr(self, "connection"):
            self.connection.commit()
            self.connection.close()