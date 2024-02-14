import mlflow
import mlflow.sklearn
from sklearn.datasets import load_iris
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler

tracking_uri = "sqlite:///mydb.sqlite"
mlflow.set_tracking_uri(tracking_uri)

data = load_iris()

X = data.data
y = data.target
features = data.feature_names

pipe = make_pipeline(StandardScaler(), LogisticRegression())
pipe.fit(X, y)


mlflow.sklearn.log_model(
    sk_model=pipe,
    artifact_path="sklearn-model",
    registered_model_name="pipeline",
)
