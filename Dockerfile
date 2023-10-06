# Use the official Python 3.8 image as the base image
FROM python:3.8

# Set the working directory inside the container
WORKDIR /app

# Install Pillow for image processing
RUN pip install Pillow

# Copy your Python script and other files into the container
COPY . /app

# Define the command to run your Python script
CMD ["python","ImageProcessingScript.py"]


