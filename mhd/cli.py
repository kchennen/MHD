import os
import time
import subprocess

import rich_click as click
import polars as pl

from tqdm import tqdm
from pprint import pprint

from mhd import logger, start_time


@click.group()
@click.version_option(version='0.1')
def cli():
    """MHD workflow CLI"""
    pass