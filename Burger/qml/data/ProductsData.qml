pragma Singleton
import QtQuick

QtObject {
    //Datos de categorías y productos
    property var categories: [
        { name: "Hamburguesas", icon: "🍔" },
        { name: "Pizzas", icon: "🍕" },
        { name: "Lomitos",  icon: "👑" },
        { name: "Pachatas",  icon: "👑" },
        { name: "Fritas",  icon: "🍟" },
        { name: "Bebidas",  icon: "🥛" }
    ]
    
    property var allProducts: [
        // Hamburguesas
        { id: Date.now() + "_" + Math.random(), category: "Hamburguesas", name: "Clásica", price: 280, image: "🍔" },
        { id: Date.now() + "_" + Math.random(), category: "Hamburguesas", name: "Doble", price: 380, image: "🍔" },
        { id: Date.now() + "_" + Math.random(), category: "Hamburguesas", name: "Especial", price: 450, image: "🍔" },
        { id: Date.now() + "_" + Math.random(), category: "Hamburguesas", name: "Premium", price: 520, image: "🍔" },
        
        // Pizzas
        { id: Date.now() + "_" + Math.random(), category: "Pizzas", name: "Común", price: 320, image: "🍕" },
        { id: Date.now() + "_" + Math.random(), category: "Pizzas", name: "Napolitana", price: 380, image: "🍕" },
        { id: Date.now() + "_" + Math.random(), category: "Pizzas", name: "Especial", price: 420, image: "🍕" },
        
        // Lomitos
        { id: Date.now() + "_" + Math.random(), category: "Lomitos", name: "Clásico", price: 220, image: "👑" },
        { id: Date.now() + "_" + Math.random(), category: "Lomitos", name: "Premium", price: 260, image: "👑" },
        { id: Date.now() + "_" + Math.random(), category: "Lomitos", name: "Completo", price: 300, image: "👑" },
        
        // Bebidas
        { id: Date.now() + "_" + Math.random(), category: "Bebidas", name: "Coca Cola", price: 50, image: "🥛" },
        { id: Date.now() + "_" + Math.random(), category: "Bebidas", name: "Fanta", price: 50, image: "🥛" },
        { id: Date.now() + "_" + Math.random(), category: "Bebidas", name: "Sprite", price: 50, image: "🥛" },

        //Pachatas
        { id: Date.now() + "_" + Math.random(), category: "Pachatas", name: "Clásica", price: 250, image: "👑" },
        { id: Date.now() + "_" + Math.random(), category: "Pachatas", name: "Completa", price: 300, image: "👑" },
        { id: Date.now() + "_" + Math.random(), category: "Pachatas", name: "Premium", price: 300, image: "👑" },

        //Fritas
        { id: Date.now() + "_" + Math.random(), category: "Fritas", name: "Clásicas", price: 250, image: "🍟" },
        { id: Date.now() + "_" + Math.random(), category: "Fritas", name: "Cheddar", price: 450, image: "🍟" },
    ]
}