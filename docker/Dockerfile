FROM python:3

ADD ./files/swpc.py /swpc.py

RUN pip install requests prometheus_client

CMD [ "python", "/swpc.py" ]
