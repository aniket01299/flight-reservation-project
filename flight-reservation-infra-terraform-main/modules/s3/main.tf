
# Create an S3 bucket
resource "aws_s3_bucket" "vanraj_bucket" {
  bucket = "vanraj-flight-reservation"

  # Enable Static Website Hosting
  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name = "VanRajFlightReservation"
    env  = "dev"
  }
}

# Disable Block Public Access
resource "aws_s3_bucket_public_access_block" "vanraj_public_access" {
  bucket = aws_s3_bucket.vanraj_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket Policy for Public Read Access
resource "aws_s3_bucket_policy" "vanraj_bucket_policy" {
  bucket = aws_s3_bucket.vanraj_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.vanraj_bucket.arn}/*"
      }
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.vanraj_public_access
  ]
}

# Output Website Endpoint
output "website_endpoint" {
  description = "Static Website URL"
  value       = aws_s3_bucket.vanraj_bucket.website_endpoint
}
