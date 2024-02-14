from google.cloud import storage
from google.oauth2 import service_account
from joblib import dump
from sklearn.datasets import load_iris
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler

data = load_iris()

X = data.data
y = data.target
features = data.feature_names

pipe = make_pipeline(StandardScaler(), LogisticRegression())
pipe.fit(X, y)

dump(features, "features.pkl")
dump(pipe, "pipe.pkl")


key_path = "./w255-secrets-6f0343c21e1b.json"
credentials = service_account.Credentials.from_service_account_file(key_path)

storage_client = storage.Client(credentials=credentials)
bucket = storage_client.bucket("w255-model-bucket")

files = ["features.pkl", "pipe.pkl"]
for file in files:
    blob = bucket.blob(file)
    blob.upload_from_filename(file)
