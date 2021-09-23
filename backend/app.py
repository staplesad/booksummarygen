from flask import Flask, send_from_directory
from .load_model import load_model, generate

app = Flask(__name__)
model, tokenizer = load_model()

print("Model Loaded")

@app.route("/")
def elm_index():
    return send_from_directory("../frontend", "index.html")

@app.route("/gen/<seed_string>")
def get_model_output(seed_string):
    if not seed_string:
        seed_string = " "
    return generate(model, tokenizer, seed_string)

if __name__=='__main__':
    app.run()
