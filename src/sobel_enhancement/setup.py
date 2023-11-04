#!/usr/bin/env python3
from setuptools import setup
from setuptools import find_packages

with open("README.md", "r") as fh:
    long_description = fh.read()

setup(
    name="Sobel control",
    version="0.1",
    author="Diana Maldonado",
    author_email="dnmaldonador@unal.edu.co",
    description=("Sobel filter for image preprocessing in hdl"),
    install_requires=['virtualenv',
                      'numpy>=1.18',
                      'matplotlib>=3.2',
                      'opencv-python',
                      'cocotb'
                      ],
)
