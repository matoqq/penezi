from flask import Flask
from flask_sqlalchemy import SQLAlchemy

debug_db_password = "jaj ;)"

db = SQLAlchemy()
app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = f"postgresql://postgres:{debug_db_password}@db.wgohgcfqldxwfpokwxui.supabase.co:5432/postgres"

db.init_app(app)

class SupaUser(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, unique=True, nullable=False)
    email = db.Column(db.String)

with app.app_context():
    db.create_all()