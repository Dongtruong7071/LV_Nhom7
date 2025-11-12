from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import or_
from dependencies import get_db, get_current_admin
from models import Product as ProductModel
from schemas import Product as ProductSchema, ProductCreate, ProductUpdate
from typing import List


router = APIRouter(prefix="/products", tags=["products"])

@router.post("/", response_model=ProductSchema)
def create_product(product: ProductCreate, db: Session = Depends(get_db), admin = Depends(get_current_admin)):
    db_product = ProductModel(**product.dict())
    db.add(db_product)
    db.commit()
    db.refresh(db_product)
    return db_product

@router.get("/", response_model=List[ProductSchema])
def read_products(
    skip: int = 0, limit: int = 20,
    search: str = None, brand_id: int = None, category_id: int = None,
    min_price: float = None, max_price: float = None,
    db: Session = Depends(get_db)
):
    query = db.query(ProductModel)
    if search:
        query = query.filter(or_(ProductModel.name.contains(search), ProductModel.ingredients.contains(search)))
    if brand_id:
        query = query.filter(ProductModel.brand_id == brand_id)
    if category_id:
        query = query.filter(ProductModel.category_id == category_id)
    if min_price:
        query = query.filter(ProductModel.price >= min_price)
    if max_price:
        query = query.filter(ProductModel.price <= max_price)
    return query.offset(skip).limit(limit).all()

@router.get("/{product_id}", response_model=ProductSchema)
def read_product(product_id: int, db: Session = Depends(get_db)):
    product = db.query(ProductModel).filter(ProductModel.id == product_id).first()
    if not product:
        raise HTTPException(404, "Product not found")
    return product

@router.put("/{product_id}", response_model=ProductSchema)
def update_product(
    product_id: int,
    product: ProductUpdate,
    db: Session = Depends(get_db),
    admin = Depends(get_current_admin)
):
    db_product = db.query(ProductModel).filter(ProductModel.id == product_id).first()
    if not db_product:
        raise HTTPException(404, "Product not found")

    update_data = product.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_product, key, value)

    db.commit()
    db.refresh(db_product)

    return db_product



@router.delete("/{product_id}")
def delete_product(product_id: int, db: Session = Depends(get_db), admin = Depends(get_current_admin)):
    product = db.query(ProductModel).filter(ProductModel.id == product_id).first()
    if not product:
        raise HTTPException(404, "Product not found")
    db.delete(product)
    db.commit()
    return {"message": "Product deleted"}