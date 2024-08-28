# Stage 1: Build stage
FROM odoo:15.0 AS builder

LABEL maintainer="Varadharajan Amotharan <varathu09@example.com>"
LABEL version="1.0"
LABEL description="Hospital Patient Management Module for Odoo 15"

ENV ODOO_USER=odoo \
    ODOO_MODULE_DIR=/mnt/extra-addons/hospital-app-demo

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements.txt and install dependencies
COPY --chown=odoo:odoo ./requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Copy the entire module directory
COPY --chown=odoo:odoo . ${ODOO_MODULE_DIR}

# Install additional dependencies if required by the module
RUN pip3 install --no-cache-dir -r ${ODOO_MODULE_DIR}/requirements.txt

# Stage 2: Final stage
FROM odoo:15.0

LABEL maintainer="Varadharajan Amotharan <varathu09@example.com>"
LABEL version="1.0"
LABEL description="Hospital Patient Management Module for Odoo 15"

USER root
RUN useradd -ms /bin/bash odoo-user \
    && mkdir -p /mnt/extra-addons \
    && chown -R odoo-user:odoo-user /mnt/extra-addons

# Copy the module from the builder stage
COPY --from=builder --chown=odoo-user:odoo-user /mnt/extra-addons/hospital-app-demo /mnt/extra-addons/hospital-app-demo

# Copy the entrypoint script and adjust permissions
COPY --chown=odoo-user:odoo-user ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER odoo-user

ENTRYPOINT ["/entrypoint.sh"]

CMD ["odoo"]

EXPOSE 8069 8072

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8069/web/status || exit 1