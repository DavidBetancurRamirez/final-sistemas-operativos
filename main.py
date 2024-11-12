from fastapi import FastAPI
from pydantic import BaseModel, field_validator
import json
import os
import uuid


app = FastAPI()
folder_path = "./data"
os.makedirs(folder_path, exist_ok=True)


# Pydantic model
class User(BaseModel):
  nombre: str
  edad: int
  profesion: str

  @field_validator("edad")
  def validar_edad_no_negativa(cls, value: int) -> int:
    if value < 0:
        raise ValueError("La edad no puede ser negativa")
    return value


# EndPoints
@app.post("/user")
async def create_user(user: User):
  payload = {
    "nombre": user.nombre,
    "edad": user.edad,
    "profesion": user.profesion,
  }

  payload_json = json.dumps(payload, ensure_ascii=False, indent=4).encode('utf-8')

  file_name = f"{str(uuid.uuid4())}-user.json"
  file_path = os.path.join(folder_path, file_name)

  with open(file_path, "wb") as json_file:
    json_file.write(payload_json)

  return {
    "message": "Usuario guardado exitosamente",
    "file_path": file_path,
    "data": user,
  }