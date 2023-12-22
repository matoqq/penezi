from flask import Flask
from reactpy import component, html
from reactpy.backend.flask import configure


@component
def HelloWorld():
    return html.h1("Hello, world!")


app = Flask(__name__)
configure(app, HelloWorld)


if __name__ == "__main__":
    app.run(debug=True)
