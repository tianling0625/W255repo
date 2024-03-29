from transformers import pipeline

text = "Welcome to the project!"

hub_path = "winegarj/distilbert-base-uncased-finetuned-sst2"
classifier = pipeline(model=hub_path, tokenizer=hub_path, device=-1, top_k=None)
print(classifier(text))
