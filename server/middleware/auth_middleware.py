from fastapi import Header, HTTPException
import jwt

def auth_middleware(x_auth_token = Header() ):
    try:

        if not x_auth_token:
            raise HTTPException(status_code=401, detail="No auth token, access denied!")
    
        #verified_token = jwt.decode(x_auth_token, 'password_key', algorithms=['HS256'])
        verified_token = jwt.decode(x_auth_token, 'password_key', algorithms=['HS256'])
       # verified_token = jwt.decode(x_auth_token[0], 'password_key', algorithms=['HS256'])
        if not verified_token:
            raise HTTPException(status_code=401, detail="Token verification failed, access denied!")

        uid = verified_token['id']
        return {'uid': uid, 'token': x_auth_token}
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="Token is not valid, access denied!")