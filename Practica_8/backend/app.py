from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app) 

@app.route('/')
def registrar():
    f = open("db/db.epk", "r")
    actual = f.read();
    f = open("db/db.epk", "w")
    f.write(str(int(actual)+1))
    f.close()
    f = open("db/db.epk", "r")
    return jsonify({'number' : f.read()})

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=7050, use_reloader=True)