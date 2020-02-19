FROM python:2.7

# Add sample application
ADD application.py /tmp/application.py
COPY . /entrypoint.sh
RUN mkdir /tmp/sample-app

EXPOSE 8000

# Run it
ENTRYPOINT ["python", "/tmp/application.py"]

CMD ["sh","entrypoint.sh"]
