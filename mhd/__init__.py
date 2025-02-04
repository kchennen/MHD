# -*- coding: utf-8 -*-
import yaml
import logging
import time
from os import path, cpu_count

# Load configs
with open(path.join(path.dirname(__file__), "config.yaml"), "r") as f:
    configs = yaml.load(stream=f, Loader=yaml.FullLoader)

start_time = time.time()
num_cores = cpu_count()  # Determine the number of threads for Parallel run
prog_name = configs['project_name']

logging.basicConfig(level=logging.INFO,
                    format='[%(asctime)s] - {prog_name} - %(levelname)s - %(message)s'.format(prog_name=prog_name),
                    datefmt='%Y-%m-%d %H:%M:%S')
logger = logging.getLogger(__name__)
