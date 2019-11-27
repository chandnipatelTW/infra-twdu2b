#!/bin/bash

sudo amazon-linux-extras install -y epel

sudo yum update -y

sudo yum install -y python-pip
sudo yum install -y gcc gcc-c++

sudo pip install apache-airflow
sudo pip install apache-airflow[crypto]
sudo pip install apache-airflow[postgres,jdbc]

export AIRFLOW_HOME=/usr/local/airflow
sudo useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow

cat | sudo tee -a $AIRFLOW_HOME/airflow.cfg > /dev/null << EOF
[core]
airflow_home = /usr/local/airflow
dags_folder = /usr/local/airflow/dags
base_log_folder = /usr/local/airflow/logs
remote_log_conn_id =
encrypt_s3_logs = False
logging_level = INFO
logging_config_class =
log_format = [%%(asctime)s] {{%%(filename)s:%%(lineno)d}} %%(levelname)s - %%(message)s
simple_log_format = %%(asctime)s %%(levelname)s - %%(message)s
executor = LocalExecutor
sql_alchemy_conn = postgresql+psycopg2://airflow:airflow@postgres/airflow
sql_alchemy_pool_size = 5
sql_alchemy_pool_recycle = 3600
parallelism = 32
dag_concurrency = 16
dags_are_paused_at_creation = True
non_pooled_task_slot_count = 128
max_active_runs_per_dag = 16
load_examples = True
plugins_folder = /usr/local/airflow/plugins
fernet_key = _2OeKKx2FG2QVEsN0svqny1LT31St1mYosNGYfpwBeI=
donot_pickle = False
dagbag_import_timeout = 30
task_runner = BashTaskRunner
default_impersonation =
security =
unit_test_mode = False
task_log_reader = file.task
enable_xcom_pickling = True
killed_task_cleanup_time = 60

[cli]
api_client = airflow.api.client.local_client
endpoint_url = http://localhost:8080

[api]
auth_backend = airflow.api.auth.backend.default

[operators]
default_owner = Airflow
default_cpus = 1
default_ram = 512
default_disk = 512
default_gpus = 0

[webserver]
base_url = http://localhost:8080
web_server_host = 0.0.0.0
web_server_port = 8080
web_server_ssl_cert =
web_server_ssl_key =
web_server_worker_timeout = 120
worker_refresh_batch_size = 1
worker_refresh_interval = 30
secret_key = temporary_key
workers = 4
worker_class = sync
access_logfile = -
error_logfile = -
expose_config = False
authenticate = False
filter_by_owner = False
owner_mode = user
dag_default_view = graph
dag_orientation = LR
demo_mode = False
log_fetch_timeout_sec = 5
hide_paused_dags_by_default = False
page_size = 100

[email]
email_backend = airflow.utils.email.send_email_smtp

[smtp]
smtp_host = localhost
smtp_starttls = True
smtp_ssl = False
smtp_port = 25
smtp_mail_from = airflow@example.com

[celery]
celery_app_name = airflow.executors.celery_executor
celeryd_concurrency = 16
worker_log_server_port = 8793
broker_url = redis://redis:6379/1
result_backend = db+postgresql://airflow:airflow@postgres/airflow
flower_host = 0.0.0.0
flower_port = 5555
default_queue = default
celery_config_options = airflow.config_templates.default_celery.DEFAULT_CELERY_CONFIG
celery_ssl_active = False

[dask]
cluster_address = 127.0.0.1:8786

[scheduler]
job_heartbeat_sec = 5
scheduler_heartbeat_sec = 5
run_duration = -1
min_file_process_interval = 0
dag_dir_list_interval = 60
print_stats_interval = 30
child_process_log_directory = /usr/local/airflow/logs/scheduler
scheduler_zombie_task_threshold = 300
catchup_by_default = True
max_tis_per_query = 0
statsd_on = False
statsd_host = localhost
statsd_port = 8125
statsd_prefix = airflow
max_threads = 2
authenticate = False

[github_enterprise]
api_rev = v3

[admin]
hide_sensitive_variable_fields = True
EOF

sudo chown -R airflow: ${AIRFLOW_HOME}
