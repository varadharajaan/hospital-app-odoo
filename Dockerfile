# Stage 1: Build stage
FROM odoo:15.0 AS builder

LABEL maintainer="Your Name <your.email@example.com>"
LABEL version="1.0"
LABEL description="Hospital Patient Management Module for Odoo 15"

ENV ODOO_USER=odoo \
    ODOO_MODULE_DIR=/mnt/extra-addons/hospital_patient

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --chown=odoo:odoo ./requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

COPY --chown=odoo:odoo ./hospital_patient ${ODOO_MODULE_DIR}

RUN pip3 install --no-cache-dir -r ${ODOO_MODULE_DIR}/requirements.txt

# Stage 2: Final stage
FROM odoo:15.0

LABEL maintainer="Your Name <your.email@example.com>"
LABEL version="1.0"
LABEL description="Hospital Patient Management Module for Odoo 15"

RUN useradd -ms /bin/bash odoo-user

ENV ODOO_USER=odoo-user \
    ODOO_MODULE_DIR=/mnt/extra-addons/hospital_patient

COPY --from=builder --chown=odoo-user:odoo-user ${ODOO_MODULE_DIR} ${ODOO_MODULE_DIR}

COPY --chown=odoo-user:odoo-user ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER ${ODOO_USER}

ENTRYPOINT ["/entrypoint.sh"]

CMD ["odoo"]