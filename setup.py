import os

# from distutils.core import setup
from setuptools import setup

this_directory = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(this_directory, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()


def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()


def requirements():
    return [line for line in read('requirements.txt').splitlines() if not line.startswith('#')]


def get_long_description():
    """Transform README.md into a usable long description.
    Replaces relative references to svg images to absolute https references.
    """

    with open('README.md') as fin:
        read_me = fin.read()

    def replace_relative_with_absolute(match):
        svg_path = match.group(0)[1:-1]
        return '(https://github.com/google/pybadges/raw/master/{}?sanitize=true)'.format(svg_path)
    return read_me


setup(
    name='MHD',                                                 # name of the package
    version='0.1.0',                                            # version of this release
    url='https://github.com/kchennen/MHD',                      # home page for the package
    download_url='https://github.com/kchennen/MHD.git',         # location where the release version may be downloaded
    author='kchennen',                                          # package author’s name
    author_email='kchennen@unistra.fr',                         # email address of the package author
    description='MHD workflow resources',
    long_description=long_description,                          # longer description package to build PyPi project page
    long_description_content_type='text/markdown',
    license='Apache 2.0',                                       # license for the package
    keywords=(                                                  # list of keywords describing the package
        "MHD workflow resources"
    ),
    install_requires=requirements(),                            # install external packages as dependencies
    packages=['mhd'],                                           # same as name
    entry_points={                                              # Register the main() function of the package
        'console_scripts': ['mhd=mhd.__main__:main'],
    },
)
