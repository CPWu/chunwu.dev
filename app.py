from flask import Flask, render_template

# Create a Flask Instance
app = Flask(__name__)


# Create a route decorator
@app.route("/")
def main():
    return render_template("index.html")


@app.route("/user/<string:name>")
def user(name):
    return "<h1>Hello {}!</h1>".format(name)
