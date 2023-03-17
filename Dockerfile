# syntax=docker/dockerfile:1.4

FROM python:3.9-slim as compiler

ENV VIRTUAL_ENV=/opt/venv
WORKDIR /app 

RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
COPY requirements.txt /app
RUN pip install -r requirements.txt

FROM python:3.9-slim as runner

ENV VIRTUAL_ENV=/opt/venv
WORKDIR /app 

COPY --from=compiler $VIRTUAL_ENV $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
COPY . /app 

RUN useradd -u 1000 djangouser
RUN chown -R djangouser /app
USER djangouser

EXPOSE 8000
ENTRYPOINT ["python3"] 
CMD ["manage.py", "runserver", "0.0.0.0:8000"]