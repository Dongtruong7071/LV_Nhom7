from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from starlette.responses import JSONResponse

from routers import users, categories, brands, products, orders, order_items
from database import engine
from models import Base
import logging

logging.basicConfig()
logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)

app = FastAPI(
    title="Cosmetic Store API",
    description="API cho ứng dụng bán mỹ phẩm Flutter",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
def create_tables():
    Base.metadata.create_all(bind=engine)

@app.get("/")
def read_root():
    return {
        "message": "Cosmetic Store API đang chạy!",
        "docs": "/docs",
        "redoc": "/redoc"
    }


app.include_router(users.router, prefix="/users", tags=["users"])
app.include_router(categories.router, prefix="/categories", tags=["categories"])
app.include_router(brands.router, prefix="/brands", tags=["brands"])
app.include_router(products.router, prefix="/products", tags=["products"])
app.include_router(orders.router, prefix="/orders", tags=["orders"])
app.include_router(order_items.router, prefix="/order-items", tags=["order_items"])

#uvicorn main:app --reload --host 127.0.0.1 --port 8000
#uvicorn main:app --reload --host 0.0.0.0 --port 8000
#uvicorn main:app --reload