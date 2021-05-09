FROM continuumio/miniconda3
RUN pip install mlflow==1.17.0 scikit-learn==0.24.2 watchdog[watchmedo] boto3

CMD mlflow server -h 0.0.0.0 --backend-store-uri sqlite:///mlflow/mlflow.db --default-artifact-root /mlflow/mlruns


