# Teardown Guide

To avoid AWS charges, destroy all resources created by Terraform.

**Steps**

1. From the project root, run:
   ```bash
   terraform -chdir=terraform destroy -auto-approve
   ```
   The S3 bucket is set with `force_destroy = true`, so Terraform will delete objects and then remove the bucket.

2. (Optional) Manually verify in the AWS Console that the EC2 instance and S3 bucket are gone.

3. Remove any local files you created (SSH keys, etc.) if desired.
