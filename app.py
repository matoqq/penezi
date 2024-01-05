from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import os

db = SQLAlchemy()
app = Flask(__name__)
db_connection_string = f"postgresql://postgres:{os.environ['DATABASE_PASSWORD']}@db.wgohgcfqldxwfpokwxui.supabase.co:5432/postgres"
app.config["SQLALCHEMY_DATABASE_URI"] = db_connection_string

db.init_app(app)

class SupaUser(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, unique=True, nullable=False)
    email = db.Column(db.String)

with app.app_context():
    print("db password:")
    print(db_connection_string)
    db.create_all()