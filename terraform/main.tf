module "website_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.10.0"

  bucket = "johnc-vue-website"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  website = {
    index_document  = "index.html"
    errror_document = "index.html"
  }

  versioning = {
    enabled = false
  }
}
