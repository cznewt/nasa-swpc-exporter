FROM python:3

ADD swpc.py /

RUN pip install requests prometheus_client

CMD [ "python", "./swpc.py" ]
