from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import or_, and_
from typing import List, Optional
from dependencies import get_db, get_current_admin
from models import Product as ProductModel, ProductVariant
from schemas import Product as ProductSchema, ProductCreate, ProductUpdate
from sqlalchemy.sql import func

router = APIRouter(prefix="/products", tags=["products"])


@router.post("/", response_model=ProductSchema)
def create_product(
    product: ProductCreate,
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin)
):
    db_product = ProductModel(**product.dict(exclude={"variants"}))
    db.add(db_product)
    db.commit()
    db.refresh(db_product)
    return db_product


@router.get("/", response_model=List[ProductSchema])
def read_products(
    skip: int = 0,
    limit: int = 20,
    search: Optional[str] = None,
    brand_id: Optional[int] = None,
    category_id: Optional[int] = None,
    min_price: Optional[float] = Query(None, description="Lọc theo giá nhỏ nhất của biến thể"),
    max_price: Optional[float] = Query(None, description="Lọc theo giá lớn nhất của biến thể"),
    in_stock: Optional[bool] = None,
    db: Session = Depends(get_db)
):

    query = db.query(ProductModel).options(joinedload(ProductModel.variants))

    if search:
        query = query.filter(
            or_(
                ProductModel.name.contains(search),
                ProductModel.ingredients.contains(search)
            )
        )

    if brand_id:
        query = query.filter(ProductModel.brand_id == brand_id)
    if category_id:
        query = query.filter(ProductModel.category_id == category_id)

    if min_price is not None or max_price is not None:
        variant_subquery = db.query(ProductVariant.product_id).distinct()
        if min_price is not None:
            variant_subquery = variant_subquery.filter(ProductVariant.price >= min_price)
        if max_price is not None:
            variant_subquery = variant_subquery.filter(ProductVariant.price <= max_price)
        variant_subquery = variant_subquery.subquery()

        query = query.join(
            ProductVariant, ProductModel.id == ProductVariant.product_id
        ).filter(ProductModel.id.in_(variant_subquery))

    if in_stock:
        query = query.join(ProductVariant).filter(ProductVariant.stock > 0)

    total = query.count()
    products = query.offset(skip).limit(limit).all()


    return products


@router.get("/{product_id}", response_model=ProductSchema)
def read_product(product_id: int, db: Session = Depends(get_db)):
    product = (
        db.query(ProductModel)
        .options(joinedload(ProductModel.variants))
        .filter(ProductModel.id == product_id)
        .first()
    )
    if not product:
        raise HTTPException(404, "Product not found")
    return product


@router.put("/{product_id}", response_model=ProductSchema)
def update_product(
    product_id: int,
    product: ProductUpdate,
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin)
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
def delete_product(
    product_id: int,
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin)
):
    product = db.query(ProductModel).filter(ProductModel.id == product_id).first()
    if not product:
        raise HTTPException(404, "Product not found")

    db.delete(product)
    db.commit()
    return {"message": "Product and all variants deleted"}