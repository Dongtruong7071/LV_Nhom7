from sqlalchemy import Column, Integer, String, Text, ForeignKey, Enum
from sqlalchemy import DECIMAL
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import DateTime

Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    firebase_uid = Column(String(128), unique=True, index=True, nullable=False)
    address = Column(Text)
    phone = Column(String(20))
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

class Category(Base):
    __tablename__ = "categories"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), unique=True, nullable=False)

class Brand(Base):
    __tablename__ = "brands"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), unique=True, nullable=False)
    logo_url = Column(String(255))
    description = Column(Text)
    created_at = Column(DateTime, server_default=func.now())

class Product(Base):
    __tablename__ = "products"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    brand_id = Column(Integer, ForeignKey('brands.id'))
    price = Column(DECIMAL(10, 2), nullable=False)
    stock = Column(Integer, default=0)
    image_url = Column(String(255))
    category_id = Column(Integer, ForeignKey('categories.id'))
    ingredients = Column(Text)
    usage_instructions = Column(Text)
    instructions = Column(Text)
    origin = Column(String(100))
    brand = relationship("Brand", back_populates="products")
    category = relationship("Category", back_populates="products")

Brand.products = relationship("Product", back_populates="brand")
Category.products = relationship("Product", back_populates="category")

class Order(Base):
    __tablename__ = "orders"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    total_amount = Column(DECIMAL(10, 2), nullable=False)
    status = Column(Enum('pending', 'paid', 'shipped', 'delivered', 'cancelled', name='order_status'), default='pending')
    shipping_address = Column(Text, nullable=False)
    created_at = Column(DateTime, server_default=func.now())

    items = relationship("OrderItem", back_populates="order")

class OrderItem(Base):
    __tablename__ = "order_items"
    id = Column(Integer, primary_key=True, index=True)
    order_id = Column(Integer, ForeignKey('orders.id'), nullable=False)
    product_id = Column(Integer, ForeignKey('products.id'), nullable=False)
    quantity = Column(Integer, nullable=False)
    price = Column(DECIMAL(10, 2), nullable=False)

    order = relationship("Order", back_populates="items")
    product = relationship("Product")