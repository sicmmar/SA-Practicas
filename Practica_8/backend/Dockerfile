FROM python:alpine3.9
COPY . /api
WORKDIR /api
RUN pip install --upgrade pip
RUN pip install flask
RUN pip install flask_cors
EXPOSE 7050
CMD python app.py