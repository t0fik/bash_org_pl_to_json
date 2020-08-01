#!/usr/bin/env python

import sys
from setuptools import setup, find_packages

setup_requires = ['setuptools', 'setuptools_scm']
if sys.version_info >= (3, 5):
    setup_requires.append('wheel >= 0.25.0')  # earlier wheels fail in 3.5
else:
    setup_requires.append('wheel')

with open('requirements.txt') as reqs:
    requirements = reqs.read().splitlines()

setup(
    name="bash-service",
    use_scm_version=True,
    packages=find_packages(),
    include_package_data=True,
    setup_requires=setup_requires,
    install_requires=requirements,
    python_requires=">=3.8",
    zip_safe=False,
    options={
        'bdist_wheel': {'universal': True},
    },
)
