
from fastapi import FastAPI, HTTPException, Depends, Header
import bcrypt
import uuid
from models.user import User
from pydantic_schemas.user_create import UserCreate
from pydantic_schemas.user_login import UserLogin
from fastapi import APIRouter
from database import get_db
from sqlalchemy.orm import Session
import jwt
from middleware.auth_middleware import auth_middleware

router = APIRouter()

@router.post('/signup', status_code=201 )
def signup_user(user: UserCreate, db: Session=Depends(get_db)):
    # check i fth euser exists  in the db
    user_db = db.query(User).filter(User.email == user.email).first()

    if user_db:
        raise HTTPException(status_code=400, detail="User email already exists")  

    # add the user to the db
    hashed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
    user_db = User(id=str(uuid.uuid4()), name=user.name, email=user.email, password=hashed_pw)
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    
    return user_db

@router.post('/login')
def login_user(user: UserLogin, db: Session=Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db:
        raise HTTPException(status_code=400, detail="Invalid email or password")

    if not bcrypt.checkpw(user.password.encode(), user_db.password):
        raise HTTPException(status_code=400, detail="Invalid email or password")

    token = jwt.encode({'id': user_db.id}, 'password_key')

    return {"token": token, 'user': user_db}

@router.get('/')
def current_user_data(db: Session = Depends(get_db), user_dict = Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uid']).first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    return user