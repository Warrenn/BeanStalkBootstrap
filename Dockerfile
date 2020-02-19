FROM python:2.7

# Add sample application
ADD application.py /tmp/application.py
COPY entrypoint.sh /entrypoint.sh

EXPOSE 8000

# Run it
ENTRYPOINT ["sh", "entrypoint.sh"]
