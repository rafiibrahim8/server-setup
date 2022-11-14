#!/bin/bash
echo "Running LPU script as user: $USER"
python3 -m pip install Flask SQLAlchemy gunicorn
