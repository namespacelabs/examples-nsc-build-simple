# syntax=docker/dockerfile:1.4

FROM python:3.9-slim as compiler

WORKDIR /app 
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY requirements.txt /app
RUN pip install -r requirements.txt

FROM python:3.9-slim as runner

WORKDIR /app 
COPY --from=compiler /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY . /app 

EXPOSE 8000
ENTRYPOINT ["python3"] 
CMD ["manage.py", "runserver", "0.0.0.0:8000"]