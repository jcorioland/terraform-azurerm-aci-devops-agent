# Pull the base image with given version.
ARG BUILD_TERRAFORM_VERSION="0.14.4"
FROM jcorioland/terraform-test:${BUILD_TERRAFORM_VERSION}

ARG MODULE_NAME="terraform-azure-devops-eagent-aci"

# Declare default build configurations for terraform.
ARG BUILD_ARM_SUBSCRIPTION_ID=""
ARG BUILD_ARM_CLIENT_ID=""
ARG BUILD_ARM_CLIENT_SECRET=""
ARG BUILD_ARM_TENANT_ID=""
ARG BUILD_ARM_TEST_LOCATION="WestEurope"
ARG BUILD_ARM_TEST_LOCATION_ALT="WestUS"

# Set environment variables for terraform runtime.
ENV ARM_SUBSCRIPTION_ID=${BUILD_ARM_SUBSCRIPTION_ID}
ENV ARM_CLIENT_ID=${BUILD_ARM_CLIENT_ID}
ENV ARM_CLIENT_SECRET=${BUILD_ARM_CLIENT_SECRET}
ENV ARM_TENANT_ID=${BUILD_ARM_TENANT_ID}
ENV ARM_TEST_LOCATION=${BUILD_ARM_TEST_LOCATION}
ENV ARM_TEST_LOCATION_ALT=${BUILD_ARM_TEST_LOCATION_ALT}

# Set environment variables for go.
ENV AZURE_SUBSCRIPTION_ID=${BUILD_ARM_SUBSCRIPTION_ID}
ENV AZURE_CLIENT_ID=${BUILD_ARM_CLIENT_ID}
ENV AZURE_CLIENT_SECRET=${BUILD_ARM_CLIENT_SECRET}
ENV AZURE_TENANT_ID=${BUILD_ARM_TENANT_ID}

# Set work directory.
RUN mkdir -p /go/src/${MODULE_NAME}
COPY . /go/src/${MODULE_NAME}
WORKDIR /go/src/${MODULE_NAME}

# Install dep.
ENV GOPATH /go
ENV PATH /usr/local/go/bin:$GOPATH/bin:$PATH
RUN /bin/bash -c "curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh"

RUN ["bundle", "install", "--gemfile", "./Gemfile"]