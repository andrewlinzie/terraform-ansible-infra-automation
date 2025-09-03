output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "web_url" {
  description = "Convenience URL to open in a browser"
  value       = "http://${aws_instance.web.public_ip}/"
}

output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.site.bucket
}
