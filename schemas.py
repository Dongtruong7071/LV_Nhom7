from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class UserBase(BaseModel):
    firebase_uid: str
    address: Optional[str] = None
    phone: Optional[str] = None

class UserCreate(UserBase):
    pass

class UserUpdate(BaseModel):
    address: Optional[str] = None
    phone: Optional[str] = None

class User(UserBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class UserRoleUpdate(BaseModel):
    uid: str
    role: str


class CategoryBase(BaseModel):
    name: str

class CategoryCreate(CategoryBase):
    pass

class Category(CategoryBase):
    id: int

    class Config:
        from_attributes = True


class BrandBase(BaseModel):
    name: str
    logo_url: Optional[str] = None
    description: Optional[str] = None

class BrandCreate(BrandBase):
    pass

class BrandUpdate(BaseModel):
    name: Optional[str] = None
    logo_url: Optional[str] = None
    description: Optional[str] = None

class Brand(BrandBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True


class ProductVariantBase(BaseModel):
    name: str  # ví dụ: "50ml", "Màu đỏ"
    price: float
    stock: Optional[int] = 0

class ProductVariantCreate(ProductVariantBase):
    pass

class ProductVariantUpdate(BaseModel):
    name: Optional[str] = None
    price: Optional[float] = None
    stock: Optional[int] = None

class ProductVariant(ProductVariantBase):
    id: int
    product_id: int

    class Config:
        from_attributes = True


class ProductBase(BaseModel):
    name: str
    brand_id: Optional[int] = None
    category_id: Optional[int] = None
    image_url: Optional[str] = None
    ingredients: Optional[str] = None
    usage_instructions: Optional[str] = None
    instructions: Optional[str] = None
    origin: Optional[str] = None

class ProductCreate(ProductBase):
    pass

class ProductUpdate(BaseModel):
    name: Optional[str] = None
    brand_id: Optional[int] = None
    category_id: Optional[int] = None
    image_url: Optional[str] = None
    ingredients: Optional[str] = None
    usage_instructions: Optional[str] = None
    instructions: Optional[str] = None
    origin: Optional[str] = None

class Product(ProductBase):
    id: int
    brand: Optional[Brand] = None
    category: Optional[Category] = None
    variants: List[ProductVariant] = []

    class Config:
        from_attributes = True


class OrderItemBase(BaseModel):
    product_id: int
    variant_id: Optional[int] = None  # nullable
    quantity: int
    price: float

class OrderItemCreate(OrderItemBase):
    pass

class OrderItemUpdate(BaseModel):
    product_id: Optional[int] = None
    variant_id: Optional[int] = None
    quantity: Optional[int] = None
    price: Optional[float] = None

class OrderItem(OrderItemBase):
    id: int
    order_id: int
    product: Optional[Product] = None
    variant: Optional[ProductVariant] = None

    class Config:
        from_attributes = True


class OrderBase(BaseModel):
    total_amount: float
    status: str = "pending"
    shipping_address: str

class OrderCreate(OrderBase):
    items: List[OrderItemCreate]

class OrderUpdate(BaseModel):
    total_amount: Optional[float] = None
    status: Optional[str] = None
    shipping_address: Optional[str] = None

class Order(OrderBase):
    id: int
    user_id: int
    created_at: datetime
    items: List[OrderItem] = []

    class Config:
        from_attributes = True