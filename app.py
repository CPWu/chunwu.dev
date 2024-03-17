from flask import Flask, render_template

# Create a Flask Instance
app = Flask(__name__)


# Create a route decorator
@app.route("/")
def main():
    last_name = "Wu"
    return render_template("index.html", last_name=last_name)


@app.route("/user/<string:name>")
def user(name):
    return render_template("user.html", name=name)


# Invalid URL
@app.errorhandler(404)
def page_not_found(e):
    return render_template("404.html"), 404


# Internal Server Error
@app.errorhandler(500)
def page_not_found(e):
    return render_template("500.html"), 500
