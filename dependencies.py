from fastapi import Depends, HTTPException, Header
from firebase_admin import credentials, auth as firebase_auth, initialize_app
from sqlalchemy.orm import Session
from database import get_db
from models import User
from dotenv import load_dotenv
import os

# load_dotenv()
# service_account_path = os.getenv("FIREBASE_SERVICE_ACCOUNT")
# if not service_account_path or not os.path.exists(service_account_path):
#     raise ValueError("Service account file not found. Check FIREBASE_SERVICE_ACCOUNT in .env")
#
# if not len(firebase_auth._apps):
#     cred = credentials.Certificate(service_account_path)
#     initialize_app(cred)


def get_current_admin():
    class DummyAdmin:
        id = 1
        role = "admin"
    return DummyAdmin()

def get_current_user():
    class DummyUser:
        id = 1
        role = "user"
    return DummyUser()


#
# async def get_current_user(authorization: str = Header(None), db: Session = Depends(get_db)):
#     if not authorization or not authorization.startswith("Bearer "):
#         raise HTTPException(status_code=401, detail="Invalid authentication credentials")
#
#     token = authorization.split("Bearer ")[1]
#     try:
#         decoded_token = firebase_auth.verify_id_token(token)
#         firebase_uid = decoded_token['uid']
#         role = decoded_token.get('role', 'user')
#
#         user = db.query(User).filter(User.firebase_uid == firebase_uid).first()
#         if not user:
#             user = User(firebase_uid=firebase_uid)
#             db.add(user)
#             db.commit()
#             db.refresh(user)
#
#         user.role = role
#         return user
#     except:
#         raise HTTPException(status_code=401, detail="Invalid authentication credentials")
#
#
# async def get_current_admin(user=Depends(get_current_user)):
#     if user.role != 'admin':
#         raise HTTPException(status_code=403, detail="Not enough permissions")
#     return user