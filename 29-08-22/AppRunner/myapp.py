from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    return 'Hi Im Arjun , this is a Web App with Python Flask run in app!'

app.run(host='0.0.0.0', port=81)