from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

# User
class UserBase(BaseModel):
    firebase_uid: str
    address: Optional[str] = None
    phone: Optional[str] = None

class UserUpdate(BaseModel):
    firebase_uid: Optional[str] = None
    address: Optional[str] = None
    phone: Optional[str] = None

class UserCreate(UserBase):
    pass

class User(UserBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class UserRoleUpdate(BaseModel):
    uid: str
    role: str

# Category
class CategoryBase(BaseModel):
    name: str

class CategoryCreate(CategoryBase):
    pass

class Category(CategoryBase):
    id: int

    class Config:
        from_attributes = True

# Brand
class BrandBase(BaseModel):
    name: str
    logo_url: Optional[str] = None
    description: Optional[str] = None

class BrandCreate(BrandBase):
    pass

class Brand(BrandBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True

# Product
class ProductBase(BaseModel):
    name: str
    brand_id: Optional[int] = None
    price: float
    stock: Optional[int] = 0
    image_url: Optional[str] = None
    category_id: Optional[int] = None
    ingredients: Optional[str] = None
    usage_instructions: Optional[str] = None
    instructions: Optional[str] = None
    origin: Optional[str] = None

class ProductCreate(ProductBase):
    pass

class Product(ProductBase):
    id: int

    class Config:
        from_attributes = True


class ProductUpdate(BaseModel):
    name: Optional[str] = None
    price: Optional[float] = None
    stock: Optional[int] = None
    brand_id: Optional[int] = None
    category_id: Optional[int] = None
    image_url: Optional[str] = None
    ingredients: Optional[str] = None
    usage_instructions: Optional[str] = None
    origin: Optional[str] = None



# Order
class OrderItemBase(BaseModel):
    product_id: int
    quantity: int
    price: float

class OrderItemCreate(OrderItemBase):
    pass

class OrderItem(OrderItemBase):
    id: int
    order_id: int

    class Config:
        from_attributes = True

class OrderBase(BaseModel):
    total_amount: float
    status: str = "pending"
    shipping_address: str

class OrderCreate(OrderBase):
    items: List[OrderItemCreate]

class Order(OrderBase):
    id: int
    created_at: datetime
    items: List[OrderItem]

    class Config:
        from_attributes = True



class BrandUpdate(BaseModel):
    name: Optional[str] = None
    logo_url: Optional[str] = None
    description: Optional[str] = None

class OrderUpdate(BaseModel):
    total_amount: Optional[float] = None
    status: Optional[str] = None
    shipping_address: Optional[str] = None

class OrderItemUpdate(BaseModel):
    product_id: Optional[int] = None
    quantity: Optional[int] = None
    price: Optional[float] = None