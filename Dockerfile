FROM python:3.8-alpine AS builder
WORKDIR /
COPY . /build
WORKDIR /build
RUN apk add git
RUN pip wheel --wheel-dir=dist/ gunicorn
RUN pip wheel -r requirements.txt --wheel-dir=dist/
RUN python setup.py  bdist_wheel --universal


FROM python:3.8-alpine

COPY --from=builder /build/dist /dist
RUN pip install --no-cache-dir --find-links /dist bash-service \
    && pip install --no-cache-dir --find-links /dist gunicorn

ENTRYPOINT [ "gunicorn","--bind=0.0.0.0", "bash_service:app" ]
EXPOSE 8000