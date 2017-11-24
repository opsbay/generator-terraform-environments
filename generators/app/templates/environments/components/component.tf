# Complete your provider information here
# Full list of providers: https://www.terraform.io/docs/providers/index.html
provider "<%= provider %>" {
    # provider parameters here
}

# Make a single call to the component module in the modules folder of this repo.
# Do not create any resources nor reference other modules here.
# That belongs in ../../../modules/<%= component %>/<%= component %>.tf
module "<%= component %>" {
    source = "../../../modules/<%= component %>"
    # other variables to be passed in go here
    environment_name = "${var.environment_name}"
    component_name = "${var.component_name}"
}

<% if (backend == "s3") { %>
terraform {
    backend "<%= backend %>" {
        bucket = "<%= backendBucketName %>"
        key    = "<%= backendBucketKeyPrefix %>/<%= environment %>/<%= component %>/terraform.tfstate"
        region = "<%= backendBucketRegion %>"
    }
}
<% for (i in components) { %><% if (components[i] != component) { %>
data "terraform_remote_state" "<%= components[i] %>" {
    backend = "<%= backend %>"
    config {
        bucket = "<%= backendBucketName %>"
        key    = "<%= backendBucketKeyPrefix %>/<%= environment %>/<%= components[i] %>/terraform.tfstate"
        region = "<%= backendBucketRegion %>"
    }
}
<% } %><% } %><% } %>