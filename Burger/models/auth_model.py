import hashlib
import secrets
import logging
from database.database_manager import DataBase
from PySide6.QtCore import QObject, Signal, Property, Slot

class AuthModel(QObject):
    
    loginSuccess = Signal()
    loginFailed = Signal(str)
    userChanged = Signal()
    logger = logging.getLogger("AuthModel")
    
    def __init__(self):
        super().__init__()
        self.db = DataBase()
        self.current_user = None
        
    def create_admin(self):
        try:
            user = "admin"
            password = "admin123"
            
            password_hash = self.hash_password(password)
            
            self.db.cursor.execute('''
                INSERT OR IGNORE INTO users (username, password_hash, role) VALUES (?, ?, ?)''',
                (user, password_hash, "administrador"))
            
            self.db.connection.commit()
        
        except Exception as e:
            self.logger.error(f"Error al crear el admin(create_admin): {e}")
        
    def hash_password(self, password, salt=None):
        
        if salt is None:
            salt = secrets.token_hex(16)
        
        hash_obj = hashlib.pbkdf2_hmac("sha256", password.encode(), salt.encode(), 600000)
        
        return salt + "$" + hash_obj.hex()
    
    def verify_password(self, password, stored_hash):
        try:
            salt, stored = stored_hash.split("$")
            hash_obj = hashlib.pbkdf2_hmac("sha256", password.encode(), salt.encode(), 600000)
            
            return hash_obj.hex() == stored
        
        except Exception as e:
            self.logger.error(f"Error al verificar contraseña(verify_password): {e}")
            return False
        
    @Slot(str, str)
    def login(self, username, password):
        try:
            self.db.cursor.execute('''
                SELECT id, username, role, password_hash FROM users WHERE username = ?''',
                (username,))
            
            user = self.db.cursor.fetchone()
            
            if user and self.verify_password(password, user[3]):
                self.current_user = {
                    "id": user[0],
                    "username": user[1],
                    "role": user[2]
                }
                self.loginSuccess.emit()
                self.userChanged.emit()
            
            else:
                self.loginFailed.emit("Usuario o contraseña incorrectos")
                
        except Exception as e:
            self.loginFailed.emit(f"Error interno. Intente nuevamente.")
            
    @Slot()
    def logout(self):
        self.current_user = None
        self.userChanged.emit()
    
    def get_current_username(self):
        if self.current_user:
            return self.current_user.get("username", "")
        
        return ""
    
    def get_user_role(self):
        if self.current_user:
            return self.current_user.get("role", "")
        
        return ""
    
    def is_authenticated(self):
        return self.current_user is not None
    
    def get_is_admin(self):
        return self.current_user and self.current_user.get("role") == "administrador"
    
    currentUsername = Property(str, get_current_username, notify=userChanged)
    currentUserRole = Property(str, get_user_role, notify=userChanged)
    isLoggedIn = Property(bool, is_authenticated, notify=userChanged)
    isAdmin = Property(bool, get_is_admin, notify=userChanged)