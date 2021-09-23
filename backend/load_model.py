from pathlib import Path

import transformers
from transformers import AutoConfig, AutoTokenizer, AutoModelForCausalLM

def load_model():
    current_dir = Path(__file__).resolve().parent
    model_loc = current_dir / '../finetuned_model'
    tok_loc = current_dir / '../finetuned_model/tokenizer'
    model = AutoModelForCausalLM.from_pretrained(model_loc)
    tokenizer = AutoTokenizer.from_pretrained(tok_loc)
    return model, tokenizer

def generate(model, tokenizer, input_string):
    P=0.9
    K=100
    min_len = 10
    max_len = 300
    model_input = tokenizer(input_string, return_tensors='pt')
    output = model.generate(**model_input, do_sample=True,
                            top_p=P, top_k=K, min_length=min_len,
                            max_length=max_len)
    return tokenizer.decode(output.tolist()[0])
