from joblib import dump
from sklearn.datasets import load_iris
from sklearn.svm import SVC

X, y = load_iris(return_X_y=True)

clf = SVC()
clf.set_params(kernel="linear").fit(X, y)

dump(clf, "model.joblib")
